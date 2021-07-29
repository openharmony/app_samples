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

export default {
    data: {
        chat: ["/common/images/ic_public_community_messages_filled.png"],
        contacts: ["/common/images/ic_public_contacts.png"],
        dynamic: ["/common/images/ic_gallery_discover.png"]
    },
    change: function(e) {
        if (e.index == 0) {
            this.chat = "/common/images/ic_public_community_messages_filled.png"
            this.contacts = "/common/images/ic_public_contacts.png"
            this.dynamic = "/common/images/ic_gallery_discover.png"
        }
        if (e.index == 1) {
            this.chat = "/common/images/ic_public_community_messages.png"
            this.contacts = "/common/images/ic_public_contacts_filled.png"
            this.dynamic = "/common/images/ic_gallery_discover.png"
        }
        if (e.index == 2) {
            this.chat = "/common/images/ic_public_community_messages.png"
            this.contacts = "/common/images/ic_public_contacts.png"
            this.dynamic = "/common/images/ic_discover_10.png"
        }
    }
}