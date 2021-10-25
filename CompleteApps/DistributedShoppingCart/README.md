# Distributed Shopping Cart

##### Introduction

This sample is developed using Java. It simulates the scenario where a user shares the shopping cart on their phone with another user through near-field communication during online shopping. It also simulates the scenario where two users merge their respective shopping carts to reach a certain amount of money (CNY 5,000 in the sample app), so that each of them can enjoy a preferential price.

##### Usage

######  1. Browsing Offerings

Open the sample app. The home screen shows the offerings, as well as their respective basic information and price.

###### 2. Adding Offerings to the Shopping Cart

Touch an offering. On the details page displayed, touch **Add to Cart" in the lower right corner. If this is the first offering added to the shopping cart, a number badge is added. Otherwise, the number badge is automatically incremented.

###### 3. Sharing a Shopping Cart

On the home screen, touch the shopping cart button on the toolbar to go to the **My Shopping Cart** page. Touch the share button (the second icon on the right) in the upper right corner. The devices with which the shopping cart can be shared are displayed. Touch a device. The shopping cart on your phone is shared to that device, and the user of that device can view your shopping cart.

###### 4. Merging the Shopping Carts

On the home screen, touch the shopping cart button on the toolbar to go to the **My Shopping Cart** page. Touch the merge button (the first icon on the right) in the upper right corner. The devices with which the shopping cart can be merged are displayed. Touch a device. The shopping cart on your phone is merged with the shopping cart on that device. If the items in the merged shopping cart can reach the amount of money specified by the merchant, both parties enjoy a preferential price.

###### 5. Settlements

On the **My Shopping Cart** page, you can select some or all offerings and touch the checkout button in the lower right corner for checkout. (You can select **All** on the toolbar to select all offerings.)

##### Constraints

1. Compilation Constraints
   
   Set up the DevEco Studio development environment.
  

   For details, see [Building the Development Environment](https://developer.harmonyos.com/en/docs/documentation/doc-guides/installation_process-0000001071425528).

2. Usage Constraints

   This sample is used to simulate online shopping. All offering data is read from files. Therefore, you need to prepare an offering list file (**product_datas.json**) and add the file under **resource/rawfile/**.

   
