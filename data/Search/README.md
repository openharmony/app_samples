# Search Service<a name="EN-US_TOPIC_0000001179782481"></a>

### Introduction<a name="section104mcpsimp"></a>

The search service provides developers with the same full-text search capabilities as a search engine. This sample demonstrates how to use common search APIs to create location index forms and insert, update, delete, and search location index data.

### Usage<a name="section107mcpsimp"></a>

1. Connect to the search service when starting an app.

2. Touch  **build location indexForm**  and create a location index form. After a success message is returned, touch  **read indexForm**. The location information index, including  **title**,  **tag**,  **bucket\_id**,  **latitude**,  **longitude**  and  **device\_id**, is displayed.

3. Touch  **insert location indexData**  and insert 10 pieces of location data. A success message is returned.

4. Touch  **update location indexData**  to update location information.

5. Touch  **get search hint count**. For example, search for "location" in the  **title**  and  **tag**  fields. The search criteria are as follows:  **bucket\_id**  and  **CommonItem.IDENTIFIER**  are from  **0**  to  **5**. An index is hit if "location" is found in  **tag**  or  **CommonItem.TITLE**. The latitude is  **\[-80.0f, 80.0f\]**, and the longitude is  **\[-90.0, 90.0\]**. Sort the search results in ascending order based on  **CommonItem.CATEGORY**, and in descending order based on  **tag**  if the values of  **CommonItem.CATEGORY**  are the same. The number of location index data records that meet the search criteria is returned.

6. Touch  **search by group** **search by page**  to query the location index data. The search criteria are the same as those in step 5. The data meeting the search criteria is returned.

7. Touch  **delete indexData by query**  or  **delete indexData**  to delete location index data.

### Constraints<a name="section110mcpsimp"></a>

This sample can only be run on large-system devices.

