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

package ohos.samples.search.utils;

import ohos.app.Context;
import ohos.data.search.SearchAbility;
import ohos.data.search.SearchSession;
import ohos.data.search.model.*;
import ohos.data.search.schema.CommonItem;
import ohos.data.search.schema.IndexSchemaType;
import ohos.utils.zson.ZSONArray;
import ohos.utils.zson.ZSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * SearchUtils
 *
 * @since 2021-07-23
 */
public class SearchUtils {
    private final String LOCAL_DEVICE_ID = "";
    private final String FILE_PATH;
    private final Context context;
    private final SearchAbility searchAbility;

    public SearchUtils(Context context, SearchAbility searchAbility) {
        this.context = context;
        this.searchAbility = searchAbility;
        FILE_PATH = context.getFilesDir().getPath();
    }

    /**
     * build indexfroms
     *
     * @return int
     */
    public int buildIndexForms() {
        searchAbility.clearIndex(SearchParameter.DEFAULT_GROUP, context.getBundleName(), null);
        searchAbility.clearIndexForm(context.getBundleName());

        // constructing custom index attributes
        List<IndexForm> indexFormList = new ArrayList<>();
        indexFormList.add( // Word segmentation, while supporting sorting and grouping
                new IndexForm("tag", IndexType.SORTED, false, true, false));
        indexFormList.add( // Support sorting and range query
                new IndexForm("bucket_id", IndexType.INTEGER, false, true, false));
        indexFormList.add( // Support range search
                new IndexForm("latitude", IndexType.FLOAT, false, true, false));
        indexFormList.add( // Support range search
                new IndexForm("longitude", IndexType.FLOAT, false, true, false));
        indexFormList.add( // Support search
                new IndexForm("device_id", IndexType.NO_ANALYZED, false, true, false));

        // constructing  index attributes using a generic template
        return searchAbility.setIndexForm(context.getBundleName(), 1, indexFormList, IndexSchemaType.COMMON);
    }

    /**
     * readIndexForms
     *
     * @return String
     */
    public String readIndexForms() {
        StringBuilder result = new StringBuilder("Result:");
        List<IndexForm> indexFormList = searchAbility.getIndexForm(context.getBundleName());
        for (IndexForm indexForm : indexFormList) {
            result.append(indexForm.toString()).append(System.lineSeparator());
        }
        return result.toString();
    }

    /**
     * insert index data
     *
     * @return int
     */
    public int insertIndexData() {
        // Create an IndexData instance.
        List<IndexData> indexDataList = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            CommonItem commonItem = new CommonItem().setIdentifier(LOCAL_DEVICE_ID + i)
                    .setTitle("position")
                    .setSubtitle("subtitle")
                    .setCategory("things")
                    .setDescription("is description")
                    .setName("name")
                    .setAlternateName("othername")
                    .setDateCreate(System.currentTimeMillis())
                    .setKeywords("key")
                    .setPotentialAction("com.sample.search.TestAbility")
                    .setThumbnailUrl(FILE_PATH)
                    .setUrl(FILE_PATH)
                    .setReserved1("reserved1")
                    .setReserved2("reserved2");
            commonItem.put("tag", "location" + i);
            commonItem.put("bucket_id", i);
            commonItem.put("latitude", i / 10.0 * 180);
            commonItem.put("longitude", i / 10.0 * 360);
            commonItem.put("device_id", "localDeviceId");
            indexDataList.add(commonItem);
        }

        // Insert a list of indexes.
        List<IndexData> failedList = searchAbility.insert(SearchParameter.DEFAULT_GROUP,
                context.getBundleName(), indexDataList);
        // If some indexes fail to be inserted, try again later.
        return failedList.size();
    }

    /**
     * update index data
     *
     * @return int
     */
    public int updateIndexData() {
        // constructing index data
        List<IndexData> indexDataList = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            CommonItem commonItem = new CommonItem().setIdentifier(LOCAL_DEVICE_ID + i).setTitle("position update");
            commonItem.put("tag", "location update" + i);
            commonItem.put("bucket_id", i + 1);
            commonItem.put("latitude", i / 10.0 * 100);
            commonItem.put("longitude", i / 10.0 * 300);
            commonItem.put("device_id", "localDeviceId");
            indexDataList.add(commonItem);
        }

        List<IndexData> failedList = searchAbility.update(SearchParameter.DEFAULT_GROUP,
                context.getBundleName(), indexDataList);
        return failedList.size();
    }

    /**
     * delete index data
     *
     * @return int
     */
    public int deleteIndexData() {
        // constructing index data
        List<IndexData> indexDataList = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            CommonItem commonItem = new CommonItem().setIdentifier(LOCAL_DEVICE_ID + i);
            indexDataList.add(commonItem);
        }

        List<IndexData> failedList = searchAbility.delete(SearchParameter.DEFAULT_GROUP,
                context.getBundleName(), indexDataList);
        return failedList.size();
    }

    /**
     * deleteIndexByQuery
     *
     * @return int
     */
    public int deleteIndexByQuery() {
        return searchAbility.deleteByQuery(SearchParameter.DEFAULT_GROUP,
                context.getBundleName(), buildQueryString().toString());
    }

    /**
     * getSearchHitCount
     *
     * @return int
     */
    public String getSearchHitCount() {
        SearchSession session = searchAbility.beginSearch(SearchParameter.DEFAULT_GROUP, context.getBundleName());
        String result = "SearchHitCount:" + System.lineSeparator();
        if (session == null) {
            return result;
        }
        try {
            String query = buildQueryString().toString();
            return result + session.getSearchHitCount(query);
        } finally {
            searchAbility.endSearch(SearchParameter.DEFAULT_GROUP, context.getBundleName(), session);
        }
    }

    /**
     * searchByGroup
     *
     * @return String
     */
    public String searchByGroup() {
        // Start a search session.
        SearchSession session = searchAbility.beginSearch(SearchParameter.DEFAULT_GROUP, context.getBundleName());
        StringBuilder result = new StringBuilder("searchByGroup:" + System.lineSeparator());
        if (session == null) {
            return result.toString();
        }
        try {
            ZSONObject query = buildQueryString();
            // SearchParameter.GROUP_FIELD_LIST indicates the field list you need to specify when calling the groupSearch method.
            query.put(SearchParameter.GROUP_FIELD_LIST, new ZSONArray(Arrays.asList("tag", CommonItem.CATEGORY)));

            int limit = 10; // A maximum of 10 groups (recommendations) are returned for each field.
            List<Recommendation> recommendationList = session.groupSearch(query.toString(), limit);

            // Process recommendations.
            for (Recommendation recommendation : recommendationList) {
                result.append(recommendation.toString()).append(System.lineSeparator());
            }
            return result.toString();
        } finally {
            searchAbility.endSearch(SearchParameter.DEFAULT_GROUP, context.getBundleName(), session);
        }
    }

    /**
     * searchByPage
     *
     * @return String
     */
    public String searchByPage() {
        // Start a search session.
        SearchSession session = searchAbility.beginSearch(SearchParameter.DEFAULT_GROUP, context.getBundleName());
        StringBuilder result = new StringBuilder("searchByPage:" + System.lineSeparator());
        if (session == null) {
            return result.toString();
        }
        try {
            String query = buildQueryString().toString();
            int count = session.getSearchHitCount(query);
            int batch = 50; // A maximum of 50 results are allowed on each page.
            for (int i = 0; i < count; i += batch) {
                List<IndexData> indexDataList = session.search(query, i, batch);
                for (IndexData indexData : indexDataList) {
                    result.append("tag:").append(indexData.get("tag")).append(", latitude:")
                            .append(indexData.get("latitude")).append(", longitude:")
                            .append(indexData.get("longitude")).append(System.lineSeparator());
                }
            }
            return result.toString();
        } finally {
            searchAbility.endSearch(SearchParameter.DEFAULT_GROUP, context.getBundleName(), session);
        }
    }

    /**
     * buildQueryString
     *
     * @return ZSONObject
     */
    public ZSONObject buildQueryString() {
        // Create a JSONObject.
        ZSONObject zsonObject = new ZSONObject();

        // SearchParameter.QUERY indicates the user input. It is recommended that the search fields be analyzed.
        // Assume that the user inputs location and starts a search for the title and tag fields.
        ZSONObject query = new ZSONObject();
        query.put("location", new ZSONArray(Arrays.asList(CommonItem.TITLE, "tag")));
        zsonObject.put(SearchParameter.QUERY, query);

        /*
         * Search criteria can be added to ZSONArray of the SearchParameter.FILTER_CONDITION.
         * An index in the index library is hit only if the search criteria of each ZSONObject in the ZSONArray is met.
         * The search criteria of a ZSONArray is met as long as one of the conditions in the search criteria is met.
         */
        ZSONArray filterCondition = new ZSONArray();

        // For the first condition, a field may have multiple values.
        ZSONObject filter1 = new ZSONObject();
        filter1.put("bucket_id", new ZSONArray(Arrays.asList(0, 1, 2, 3, 4, 5))); // An index is hit if its value is 0, 1, 2, 3, 4, or 5 for the bucket_id field.
        filter1.put(CommonItem.IDENTIFIER, new ZSONArray(Arrays.asList(0, 1, 2, 3, 4, 5))); // The index is also hit if its value is 0 , 1, 2, 3, 4 or 5 for the CommonItem.IDENTIFIER field.
        filterCondition.add(filter1);
        ZSONObject filter2 = new ZSONObject();
        filter2.put("tag", new ZSONArray(Collections.singletonList("position")));
        filter2.put(CommonItem.TITLE, new ZSONArray(Collections.singletonList("position"))); // An index is hit if the value of the tag or CommonItem.TITLE field is position.
        filterCondition.add(filter2);
        zsonObject.put(SearchParameter.FILTER_CONDITION, filterCondition); // An index is hit only if both the first and second conditions are met.

        // SearchParameter.DEVICE_ID_LIST indicates the device ID list. Indexes with the specified IDs are hit.
        ZSONObject deviceId = new ZSONObject();
        deviceId.put("device_id", new ZSONArray(Collections.singletonList("localDeviceId"))); // Specify the local device.
        zsonObject.put(SearchParameter.DEVICE_ID_LIST, deviceId);

        // Start a search by specifying the value range of a specified index field.
        // Indexes whose values fall within the value range of the specified index field are hit.
        ZSONObject latitudeObject = new ZSONObject();
        latitudeObject.put(SearchParameter.LOWER, -80.0f);
        latitudeObject.put(SearchParameter.UPPER, 80.0f);
        zsonObject.put("latitude", latitudeObject); // The latitude must be in the range of [-80.0f, 80.0f].
        ZSONObject longitudeObject = new ZSONObject();
        longitudeObject.put(SearchParameter.LOWER, -90.0);
        longitudeObject.put(SearchParameter.UPPER, 90.0);
        zsonObject.put("longitude", longitudeObject); // The longitude must be in the range of [-90.0, 90.0].

        /*
         * SearchParameter.ORDER_BY indicates how the search results are sorted.
         * The value can be SearchParameter.ASC or SearchParameter.DESC.
         * The sequence of the fields matters.
         * In the following example, indexes are first sorted in ascending order of the CommonItem.CATEGORY field.
         * If they are equal on the CommonItem.CATEGORY field, they will be sorted in descending order of the tag field.
         */
        ZSONObject order = new ZSONObject();
        order.put(CommonItem.CATEGORY, SearchParameter.ASC);
        order.put("tag", SearchParameter.DESC);
        zsonObject.put(SearchParameter.ORDER_BY, order);

        // Obtain the string for search.
        return zsonObject;
    }
}
