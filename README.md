# Quick start example for iOS
<p>This project helps you get started integrating the current web-codeless SDK on iOS.</p>

# Description
<p>The package contains a brief working example integrating the SDK with one data vendor.
Replace the values key, journey token, and journey data with the proper values relevant to your application.</p>

# Getting started
<p>
1. Ensure you have Xcode version 14.0 or above installed on your computer.<br />
2. Download the Quick App iOS project files from the repository.<br />
3. Ensure the Alloy SDK package gets installed while opening. We are using Switf Package Manager.<br />
4. Open the project files in Xcode.<br />
5. Review the code and make sure you understand what it does.<br />
6. Update the values for the key, journey token, and journey data <br />
7. Run it on an actual device.<br />
</p>

# Usage
Once everything is working, change production to true before releasing your application.
## Production vs Sandbox
Whether using production or sandbox, `production` and `realProduction` should be true. 
To change between sandbox and production you will want to change the production boolean in JourneySettings 
## SDK settings
Use the AlloySettings function to establish your SDK settings.
```
                AlloySettings(
                            apiKey: “Your-API-Key”,
                            production: true,
                            realProduction: true,
                            codelessFinalValidation: false
                            )
                        
```

apiKey should be the SDK key from your Alloy dashboard. 

## Journey Settings
The JourneySettings function is used to establish if this is production and which journey in Alloy you are using. In this step you will also include all entities you want Alloy to process. 

```let journeySettings = JourneySettings(journeyToken: “J-XXXX-Token”, entities: entities, production:false)```

The journeyToken can be retrieved from your Alloy dashboard, the entities will contain an array of entities to be processed by Alloy. 

# Dependencies
[Alloy Codeless Lite iOS](https://github.com/UseAlloy/alloy-codeless-lite-ios)