#  Componentization

### Introduction

This sample demonstrates how custom components work, including one-way and two-way data binding and page rendering. The @Component, @builder, @Extend, and @BuilderParam decorators make the code more modular and reusable, improving the code reading efficiency. The home page consists of the carousel component on the top, statistics component in the middle, and **\<TabContent>** component at the bottom. When data on a page changes, the related variables of other components change accordingly, and the page is refreshed in a timely manner.

### Usage

1. When you touch the Live review button in the carousel component on the top or the Release video cover on the left of **\<ListItem>** on the **TabContent** page at the bottom, the number of views in the statistics component increases by 1.
2. When you touch the Live reminder button in the carousel component on the top or the Reminder in the **\<ListItem>** on the **TabContent** page at the bottom, the buttons as well as the icons of the related items in the carousel component and the **TabContent** page change, number of views in the statistics component increases by 1.
3. Touch the Favorites button of **\<ListItem>** on the **TabContent** page at the bottom. The number of favorite videos in the middle statistics component increases by 1, and the icons of related items on other content pages in the **\<TabContent>** component at the bottom are also updated.

### Constraints

This sample can only be run on standard-system devices.
