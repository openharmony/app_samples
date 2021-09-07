# JSUICustomComponent



### Introduction

A custom component is one that combines existing components based on service requirements. A custom component can be invoked multiple times in a project to improve the code readability. This sample illustrates how to use custom components in JavaScript, including basic usage, custom events, props, and event parameters.

### Usage

1. The home screen of the sample application is a simple list of recommended e-books. The items in the list are custom components, which are introduced to the host page through **element**. When a user clicks **Collect** or **Collected** on a child component, the click event passes parameters to the parent component. After obtaining the parameters, the parent component updates the e-book status (collected or not) and passes the parameters to the child component through attributes. The text displayed in the child component then changes to **Collected** or **Collect**, depending on the e-book status.

2. When a user clicks **Enter collected**, the system adds the e-book in **Collected** state to the **Collected** list and passes the list as a parameter to the **Collected** page. When the user accesses the **Collected** page, the e-books added to the **Collected** list are displayed. The items in the list are still custom components.

### Constraints

This sample can only be run on standard-system devices.
