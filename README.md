# Test Application for OfferReady Hubspot PlugIn
The OfferReady Hubspot PlugIn can only be used in conjunction with an OpenEndpoints application.
This application is a demo that can be used to test the PlugIn.

## Get the Plugin
See: https://www.offerready.com/hubspot/installation

## Using This Demo Application
During the setup of the plugin you will be asked to enter endpoints for "items" and "action".

This application is provided for free on an OfferReady server. The corresponding URLs are available as default values when installing the plug-in.

## Create Your Own Application
To create your own custom application, download OpenEndpoints and set up your own configuration. You can find a detailed documentation here:
https://openendpoints.gitbook.io/doc/

To enable the **Hubspot PlugIn** you need 2 endpoints. Both are implemented in this demo as examples.

### Item Endpoint
The name of the endpoint does not have to be "item" - you can use any name. The only important thing is that a JSON with the menu structure (for display in the Hubspot plugin) is returned.

```
   menu: {
    item: {
      objectId: string | number;
      action: "download" | "task";
      scope: "contact" | "company";
      caption: string;
    }[];
  };
}
```
- **Scope** defines where (within Hubspot) this menu item will be displayed.
- **Action** either is _download_ or _task_. A task returns only a success message (while any kind of task is executed in the background). A download returns a link to download a file.

### Action Endpoint
The name of the endpoint does not have to be "action" - you can use any name.

Technically, the action endpoint sends a payload with all Hubspot properties (according to the scope). This JSON payload is converted into XML by OpenEndpoints and then processed accordingly.

The endpoint URL must be entered in the setup of the plug-in without the query parameter "objectId" - because this is automatically added in the plug-in. When the menu item is selected in the PlugIn, the objectId is determined and this is then sent with the "action". If you want to support different objectIds, then the action-endpoint needs a "switch" that performs the correct action depending on the objectId.

The response expected by the Hubspot plugin depends on whether the "action" (as defined in the menu) is a "task" or a "download".

#### Response for "Task":
See file in directory "static" => dummy-email-response.json

```
interface ActionItemResponse {
  status: "success";
  message: string;
}
```
- **Status** is "success" or "error".
- **Message** is the text displayed in Hubspot.

#### Response for "Download":

```
interface ActionItemResponse {
  status: "success";
  "download-link": string;
}
```

Technically, it doesn't matter how you build the download link. But in OpenEndpoints, of course, it makes sense to use a short link for this. See: https://openendpoints.gitbook.io/doc/configuration/tasks/create-shortlink-task?q=shortlink

