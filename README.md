# TestFairy for ANE

Add AirTestFairy.ane to your project inorder to enable TestFairy

* Download and unzip the repository
* Go to your project properties

  ![Copy plugins](https://github.com/adamkan/ane/blob/master/properties.png)
  
* Choose "Flex Build Path" from the properties and choose "Native Extensions" tab

  ![Copy plugins](https://github.com/adamkan/ane/blob/master/build_path.png)
  
* Press "Add ANE" on the left and add path to AirTestFairy.ane

  ![Copy plugins](https://github.com/adamkan/ane/blob/master/ane.png)
  
* Go to "Flex Build Packaging" from the properties, choose "Apple iOS" and then "Native Extensions" tab. 
  Make sure the Package is selected
  
  ![Copy plugins](https://github.com/adamkan/ane/blob/master/package.png)
  
* In your projects PROJECT-NAME-app.xml add you APIKey as a value for "TestFairyAPIKey" key

  ![Copy plugins](https://github.com/adamkan/ane/blob/master/key.png)
  
* Import com.testfairy.AirTestFairy class and add AirTestFairy.begin();

```
  import com.testfairy.AirTestFairy;

  AirTestFairy.begin();
```

### You are ready to build and run your project
