# TestFairy for ANE

## Installation

Please follow the next steps to include the TestFairy SDK ANE in your AIR project:

1. [Download latest version](https://app.testfairy.com/ios-sdk/TestFairySDK-1.4.4.ane) to your computer.
2. Open your project properies, click on `Project` menu, and select **Properties**.
3. Select `Flex Build Path` or `ActionScript Build Path` from left sidebar, click on **Native Extensions**.
4. Click **Add ANE**, type in the path to the ANE you just downloaded.
5. Select `Flex Build Packaging` or `ActionScript Build Packaging**, select `Apple iOS`. Now select the **Native Extensions** tab.
6. Make sure the **Package** checkbox is checked.

If you are developing using Adobe Flex, add an import and a call to your `onApplicationComplete` method. For AS3 projects, add the code to your main function.

```
  import com.testfairy.AirTestFairy;

  AirTestFairy.begin(APP_TOKEN);
```

Replace ***APP_TOKEN*** with your app token value taken from the [User Preferences](https://app.testfairy.com/settings/) page.

### You are ready to build and run your project
