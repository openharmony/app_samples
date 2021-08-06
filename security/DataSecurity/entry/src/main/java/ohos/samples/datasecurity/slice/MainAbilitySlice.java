/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.datasecurity.slice;

import ohos.samples.datasecurity.MainAbility;
import ohos.samples.datasecurity.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.security.keystore.KeyGenAlgorithmParaSpec;
import ohos.security.keystore.KeyStoreConstants;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.Base64;
import java.util.Objects;
import java.util.Optional;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final String PLAIN_TEXT = "Hello World!";

    private static final String KEY_STORE = "HarmonyKeyStore";

    private static final String KEY_PAIR_ALIAS = "HarmonyKeyPair";

    private static final String ENCRYPT_ALGORITHM = "RSA/ECB/OAEPWithSHA-256AndMGF1Padding";

    private static final String PROVIDER = "HarmonyKeyStoreBCWorkaround";

    private static final String SIGNATURE_PADDING = "PSS";

    private Text resultText;

    private String result;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initComponents();
    }

    private void initComponents() {
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);
        Component encryptButton = findComponentById(ResourceTable.Id_encrypt_button);
        Component decryptButton = findComponentById(ResourceTable.Id_decrypt_button);
        encryptButton.setClickedListener(component -> encrypt());
        decryptButton.setClickedListener(component -> decrypt());
    }

    private Optional<KeyPair> getSecKey() {
        try {
            KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(KeyStoreConstants.SEC_KEY_ALGORITHM_RSA,
                KEY_STORE);
            KeyGenAlgorithmParaSpec.Builder builder = new KeyGenAlgorithmParaSpec.Builder(
                KEY_PAIR_ALIAS).setSecKeyUsagePurposes(
                KeyStoreConstants.PURPOSE_CAN_ENCRYPT | KeyStoreConstants.PURPOSE_CAN_DECRYPT
                    | KeyStoreConstants.PURPOSE_CAN_SIGN | KeyStoreConstants.PURPOSE_CAN_VERIFY)
                .addSecKeyCryptoAttr(KeyStoreConstants.CRYPTO_PARAMETER_BLOCK_MODE,
                    KeyStoreConstants.SEC_BLOCK_MODE_ECB)
                .addSecKeyCryptoAttr(KeyStoreConstants.CRYPTO_PARAMETER_ENCRYPT_PADDING,
                    KeyStoreConstants.OPTIMAL_ASYMMETRIC_ENCRYPTION_PADDING)
                .addSecKeyCryptoAttr(KeyStoreConstants.CRYPTO_PARAMETER_DIGEST,
                    KeyStoreConstants.DIGEST_ALGORITHM_SHA256)
                .addSecKeyCryptoAttr(KeyStoreConstants.CRYPTO_PARAMETER_SIGNATURE_PADDING, SIGNATURE_PADDING);
            KeyGenAlgorithmParaSpec keyGenAlgorithmParaSpec = builder.createKeyGenAlgorithmParaSpec();
            keyPairGenerator.initialize(keyGenAlgorithmParaSpec);
            return Optional.of(keyPairGenerator.generateKeyPair());
        } catch (NoSuchProviderException | NoSuchAlgorithmException | InvalidAlgorithmParameterException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "getSecKey exception.");
            return Optional.empty();
        }
    }

    private void encrypt() {
        try {
            Optional<KeyPair> keyPairOptional = getSecKey();
            if(keyPairOptional.isPresent()) {
                KeyPair keyPair = keyPairOptional.get();
                Cipher cipher = Cipher.getInstance(ENCRYPT_ALGORITHM, PROVIDER);
                cipher.init(Cipher.ENCRYPT_MODE, keyPair.getPublic());
                byte[] bytes = cipher.doFinal(PLAIN_TEXT.getBytes(StandardCharsets.UTF_8));
                result = Base64.getEncoder().encodeToString(bytes);
                resultText.setText(result);
            }
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | NoSuchProviderException
            | InvalidKeyException | BadPaddingException | IllegalBlockSizeException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "encrypt exception.");
        }
    }

    private void decrypt() {
        if (Objects.isNull(result) || PLAIN_TEXT.equals(result)) {
            HiLog.error(LABEL_LOG, "%{public}s", "result is null or " + PLAIN_TEXT.equals(result));
        } else {
            try {
                KeyStore keyStore = KeyStore.getInstance(KEY_STORE);
                keyStore.load(null);
                Key key = keyStore.getKey(KEY_PAIR_ALIAS, null);
                PrivateKey privateKey;
                if (key instanceof PrivateKey) {
                    privateKey = (PrivateKey) key;
                } else {
                    HiLog.error(LABEL_LOG, "key is not instance of PrivateKey.");
                    return;
                }
                byte[] bytes = Base64.getDecoder().decode(result);
                Cipher cipher = Cipher.getInstance(ENCRYPT_ALGORITHM, PROVIDER);
                cipher.init(Cipher.DECRYPT_MODE, privateKey);
                result = new String(cipher.doFinal(bytes)).trim();
                resultText.setText(result);
            } catch (KeyStoreException | CertificateException | IOException | NoSuchAlgorithmException
                | UnrecoverableKeyException | NoSuchPaddingException | NoSuchProviderException
                | InvalidKeyException | BadPaddingException | IllegalBlockSizeException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "decrypt exception.");
            }
        }
    }
}

