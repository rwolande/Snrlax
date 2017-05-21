# SNRLAX

![Snrlax: Simple, Fluff-less, Swift Networking](https://s-media-cache-ak0.pinimg.com/236x/36/e8/6f/36e86ffe87d0a3b0348461b9650768ed.jpg?noindex=1)

[![Twitter](https://img.shields.io/badge/twitter-@SnrlaxSwift-blue.svg?style=flat)](http://twitter.com/SnrlaxSwift)

<!-- [![Build Status](https://travis-ci.org/rwolande/Snrlax.svg?branch=master)](https://travis-ci.org/rwolande/Snrlax)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Alamofire.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/Alamofire.svg?style=flat)](http://cocoadocs.org/docsets/Alamofire)-->

**S**wift-**N**ative **R**EST-compliant **L**ibrary for **A**synchronous **T**ransactions

**Snrlax** is the leanest HTTP(S) networking library for iOS, making it wildly easy to _securely_ exchange information with any remote API. 

Developed for both ease of use and familiarity, Snrlax uses concise syntax and method delegation to fit in swimmingly alongside the Swift 3 standard library. This allows new iOS developers to adapt future-leaning habits while still allowing experienced developers to follow patterns they are already comfortable with.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
    - [Configuration](#configuration)
    - [API Networking](#api-networking)
        - [Making a Request](#making-a-request)
        - [Response Handling](#handle-a-response)
        - [Response Validation](#response-validation)
        - [Response Caching](#response-caching)
    - [Media Transactions](#media-transactions)
- [Extension Libraries](#extension-libraries)
- [Communication](#communication)
- [Open Radars](#open-radars)
- [FAQ](#faq)
- [Credits](#credits)
- [License](#license)

# Features

- [x] Written originally and entirely in Swift
	- [x] Removes need for Obj-C Bridging
	- [x] Leaves behind outdated patterns found in libraries based on pre-Swift practices
	- [x] Much smaller than Alamofire, AFNetworking, and Firebase
- [x] HTTP Secure by Default
- [x] Network Activity Indicator Management by Default
	- [x] Dynamically display when requests are in progress and hide when all requests are complete or suspended
	- [ ] Optional delegate for additional custom 'loading' widgets (UI elements)
- [x] HTTP Response Code Validation by Default
- [x] Easily customizable request header Key-Value Pairs
- [x] Protocols for variable request results
- [x] Authentication with URLCredential
- [x] _Enforced_ asynchronious transactions
	- [x] Much like Snorlax multitasks while RESTing, your application must be multi-thread compliant. This pushes developers to write UX-considerate code.
- [x] Dynamic response management, through both **polymorphism** and/or **delegation**

**v1.0 Release Promises**

- [ ] Download File using Request or Resume Data
	- [x] Request
	- [ ] Resume Data
- [ ] Upload File / Data / Stream / MultipartFormData 
- [ ] Chainable Request / Response Methods
	- [ ] Network request -> New Task
	- [ ] File download -> New Task
	- [ ] File upload -> New Task
- [ ] Dynamically Adapt and Retry Requests
- [ ] TLS Certificate and Public Key Pinning
- [ ] Network Reachability
- [ ] User Interface Bindings
	- [x] UIImageView
	- [ ] UITableView
	- [ ] SnrlaxVideoView
- [ ] Comprehensive Unit and Integration Test Coverage
- [ ] [Complete Documentation](http://cocoadocs.org/docsets/Snrlax)

# Requirements

- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+

# Installation

## CocoaPods

[CocoaPods](http://cocoapods.org) is a centralized dependency manager for Cocoa projects. Assuming you have Ruby, you can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build release version of Snrlax 1.0.0+.

To integrate Snrlax into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target '<Your Target Name>' do
    pod 'Snrlax', '~> 0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

## Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Snrlax into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "rwolande/Snrlax" ~> 0.1
```

Run `carthage update` to build the framework and drag the built `Snrlax.framework` into your Xcode project.

## Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. Be aware that the Swift Package Manager is in early development; this said, Snrlax does support its use on supported platforms.

Once you have your Swift package set up, adding Snrlax as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/rwolande/Snrlax.git", majorVersion: 0)
]
```

### Embedded Framework

- Due to the nature of a Snrlax being a quick and nimble networking library, we anticipate many developers using Snrlax as they learn Swift. Due to the nuances and bloat of embedded frameworks, we strongly discourage their use in general and ask only professionals consider their use with Snrlax.

---

# Usage

Snrlax is a great library for API networking as well as media transactions.

## API Networking

To use Snrlax, there are a few easy steps you'll want to follow:

**1x per project**

1) [Install Snrlax](#installation)
2) Import Snrlax in relevant Swift scripts
```swift
import Snrlax
```
3) [Configure](#configuration) your instance to reflect your API.

**0-1x per request**

4) [Make Request](#making-a-request)
5) [Handle Response](#handle-a-response)

### Configuration

A singleton for Snrlax will be your primary instance
```swift
Snrlax.shared
```

It can be configured by assigning an instance of SnrlaxServiceConfiguration
```swift
let YOUR_HOST_DOMAIN = "api.snrlax.com/"
Snrlax.shared.configuration = SnrlaxServiceConfiguration(host: YOUR_HOST_DOMAIN)
```
HTTPS is assumed by default. We encourage you to use SSL (HTTPS) for all data transfers. In the event you must use an unecrypted connection, you can turn SSL off in your configuration

```swift
Snrlax.shared.configuration!.ssl = false //HTTP://\(YOUR_HOST) Requests
```

If you need to include custom header Key-Value pairs, simply include them in your Snrlax configuration initializer.

```swift
Snrlax.shared.configuration = SnrlaxServiceConfiguration(host: YOUR_HOST_DOMAIN, header_keys: ["user":"abc"])
```

You can also override the current header keys whenever you like.

```swift
Snrlax.shared.configuration!.header_keys = ["user":"def","extra":"param"]
```

### Making a Request

#### Passing Body Data: QueryDataSource

Oftentimes, you'll want to include custom paramaters with your request. This is where Snrlax shines, both with it's Swifty signatures and it's dynamic overloading ability. A class which conforms to QueryDataSource can optionally implement a `body()` function to return custom parameters.

##### QueryDataSource Methods
```swift
func body(query: SnrlaxQuery) -> [String:Any]
```

```swift
class ViewController: UIViewController, QueryDataSource
{
	func body(query: SnrlaxQuery) -> [String:Any]
	{
		return [
		"universities": [
			1,2,3],
    	"coordinate": [
    		"latitude": "42.24", "longitude" : "-83.1"],
        "inputted_text": "Hello Kanto!"]
	}
}
```

Including the `data_source` parameter with `request()`:
```swift
class ViewController: UIViewController, QueryDataSource
{

        override func viewDidLoad()
        {
                super.viewDidLoad()
                
                let endpoint = SnrlaxEndpoint(literal: "user/2") //Domain-specific route
                Snrlax.shared.request(endpoint: endpoint, parser_delegate: nil, data_source: self) //data_source -> QueryDataSource
        }
        
        //Will now be called back when forming request
        func body(query: SnrlaxQuery) -> [String:Any]
	{
		return [
		"universities": [
			1,2,3],
    	"coordinate": [
    		"latitude": "42.24", "longitude" : "-83.1"],
        "inputted_text": "Hello Kanto!"]
	}
}
```

### Handle a Response

#### Response Management: QueryDelegate

One of the many advantages of Snrlax is it's rather Swifty response management. Following Apple's lead, Snrlax opts to use delegatation (protocol inheritance) over closures for response management. Any class which will process and parse a JSON result must conform to the QueryDelegate protocol.

##### QueryDelegate Methods
```swift
func successful_query(query: SnrlaxQuery, body: [String : AnyObject])
func failed_query(query: SnrlaxQuery, error: NSError?)
```

A slightly more practical implementation:
```swift
class ViewController: UIViewController, QueryDelegate
{

        override func viewDidLoad()
        {
                super.viewDidLoad()
                
                let endpoint = SnrlaxEndpoint(literal: "user/2") //Domain-specific route
                Snrlax.shared.request(endpoint: endpoint, parser_delegate: self) //parser_delegate -> QueryDelegate
        }
        
        //Optional
        func successful_query(query: SnrlaxQuery, body: [String : AnyObject])
        {
                print(body)
        }
        
        //Optional
        func failed_query(query: SnrlaxQuery, error: NSError?)
        {
                
        }
}
```

Handling the `Response` of a `Request` made in Snrlax is straight forward. All keys from your API will be root-keys of the body `Dictionary` passed in `successful_query()`.

- In the event a `JSONArray` is returned from your API at the root level, the body will have 1-root key: "data", which will map to your array values.

- At least one key will always be included in Underlying data will be found at the root level. This minimizes much of the 'Swift Optional Dance' while also keeping your data concise and most easily processed.

Finally, an actually practical implementation of `successful_query()`
```swift

let API_MESSAGES_KEY = "messages"
let API_META_KEY = "meta"

func successful_query(query: SnrlaxQuery, body: [String : Any])
{

	guard let raw_messages = body[API_MESSAGES_KEY] as? [Any]
	else
	{
		//No messages
		return
	}

	for message in raw_messages
	{
		//Process each message as you like: local memory, core data, etc.
	}

	DispatchQueue.main.async (execute: {
		//Optionally cease displaying any 'loading' widgets or update heuristics
                                self.tableView.reloadData()
                })
}
```

#### Inheriting QueryDataSource & QueryDelegate

We encourage Snrlax users to create a pair of custom classes to conform to QueryDelegate and QueryDataSource.

>Both QueryDelegate functions are optional so all conforming classes will compile.
```swift
class ViewController: UIViewController, QueryDelegate, QueryDataSource {
}
```

##### Default Body Data
In the case you consistently provide default body parameters, Snrlax offers a boiler-plate-minimizing solution by always including a body assuming: `Snrlax.shared.global_data_source != nil`.

- In the event you pass a `data_source` to the `request()` method, both bodies will be included as one combined body. If there is a key collision, the passed QueryDataSource will take precedence over the global QueryDataSource.


```swift
public class DefaultQueryDataSource: QueryDataSource
{
        static let shared = DefaultQueryDataSource()
        public func body(query: SnrlaxQuery) -> [String:Any]
        {
                return [
                        "coordinate": [
                                "latitude": "42.24", "longitude" : "-83.1"]]
        }
}

Snrlax.shared.global_data_source = DefaultQueryDataSource.shared
```

##### Default Response Delegate
It is highly encouraged that you also have a global response delegate. To provide a 2017-quality user experience, users expected heuristics indicating different states like success, pending, and failed. This is particularly useful with the modern UITableView "Scroll Down to Refresh" experience. You might find the following as a good template:


```swift
public class DefaultQueryDelegate: QueryDelegate
{
        static let shared = DefaultQueryDelegate()
        func successful_query(query: SnrlaxQuery, body: [String : AnyObject])
        {
                //Parse application-common parameters
                //Display any Application-Window level heuristics
        }
        
        func failed_query(query: SnrlaxQuery, error: NSError?)
        {
                //Display UIAlertViewController or custom alert heuristic
        }
}

Snrlax.shared.global_parser_delegate = DefaultQueryDelegate.shared
```
-Snrlax.shared.global_parser_delegate will process the query result before a query-specific delegate is called. Notably, this is done on a background thread, so you can safely assume all data modified in your global class. This cleanly seperates your data management to allow you to update the interface on the main thread within your custom handler method.

> Networking with Snrlax is done _asynchronously_. Asynchronous data request management is an integral aspect of modern application development and, in agreement with [Apple](https://developer.apple.com/library/ios/qa/qa1693/_index.html), Snrlax was developed with this in mind.

> If no encoding is specified, Snrlax will use the text encoding specified in the `HTTPURLResponse` from the server. If the text encoding cannot be determined by the server response, it defaults to `.isoLatin1`.

> All JSON serialization is handled by the `JSONSerialization` API in the `Foundation` framework. Unlike the Alamofire underpinnings, multiple response handlers will still only require server data to be serialized a single time. With large body loads, this can make Snrlax O(n)-times faster than Alamofire.


### Response Validation

By default, Snrlax treats any completed request to be successful, regardless of the content of the response. Calling `validate` before a response handler causes an error to be generated if the response had an unacceptable status code or MIME type.

#### Response Code Validation
Response handling is not configured by default. To perform validation of the `HTTPURLResponse` from your API, you can assign maps to your configuration class, one for 'accepted codes' and one for 'problematic codes'.

> For example, response status codes in the `400..<500` and `500..<600` ranges do NOT automatically trigger an `Error`.

<!-- Alamofire uses [Response Validation](#response-validation) method chaining to achieve this. -->

<!-- #### Automatic Validation

Automatically validates status code within `200..<300` range, and that the `Content-Type` header of the response matches the `Accept` header of the request, if one is provided.

```swift
Alamofire.request("https://httpbin.org/get").validate().responseJSON { response in
    switch response.result {
    case .success:
        print("Validation Successful")
    case .failure(let error):
        print(error)
    }
}
``` -->

### Response Caching

Response Caching is handled on the system framework level by [`URLCache`](https://developer.apple.com/reference/foundation/urlcache). It provides a composite in-memory and on-disk cache and lets you manipulate the sizes of both the in-memory and on-disk portions.

> By default, Snrlax leverages the shared `URLCache`. In order to customize it, see the [Session Manager Configurations](#session-manager) section.

### HTTP Methods

The `RESTmethod` enumeration lists many the HTTP methods defined in [RFC 7231 §4.3](http://tools.ietf.org/html/rfc7231#section-4.3):

```swift
public enum RESTmethod
        {
                case POST
                case GET
                case PUT
                case DELETE
                
                var includes_body: Bool
                {
                        return self == .POST || self == .PUT
                }
                
                var string: String
                {
                        switch self
                        {
                        case .POST:
                                return "POST"
                        case .GET:
                                return "GET"
                        case .PUT:
                                return "PUT"
                        case .DELETE:
                                return "DELETE"
                        }
                }
        }
```

These values can be passed as the `method` argument to the `SnrlaxEndpoint` API:

```swift
let USER_ROUTE = "user"

//Case 1
let endpoint = SnrlaxEndpoint(literal: USER_ROUTE + "/2") //Method defauls to get
Snrlax.shared.request(endpoint: endpoint)

//Case 2
let endpoint = SnrlaxEndpoint(literal: USER_ROUTE + "/2", method: .GET) //Same as above
Snrlax.shared.request(endpoint: endpoint)

//Case 3
let endpoint = SnrlaxEndpoint(literal: USER_ROUTE, method: .POST) //Post method will be used
Snrlax.shared.request(endpoint: endpoint)
```

This allows common RESTful practices to be mirrored in Swift. Routes can be recycled with different appendments (as seen above) and also with different methods.

> The `SnrlaxEndpoint.rest_method` parameter defaults to `.get`.

## Media Transactions

`Snrlax` provides it's own caches, `SnrlaxMediaCache`. `SnrlaxMediaManager` has an array of `SnrlaxMediaCache`s. By default, there is one for thumbnails, one for higher-quality images, and one for video data. When you make a request for an image that you have not yet cached, if a corresponding thumbnail has been cached it will be used until the higher-quality image is fully received.

### Downloading Media

To download an image, call the `pull` method of your shared instance: `Snrlax.shared.media_manager.pull()`.

The first argument is a required string and the second is an enum `SnrlaxMediaManager.MediaType`. This is specified so the correct cache is used, and so thumbnails can be used if available.

Finally, optionally pass a UIImageView, which will be updated _asynchronously_. Unlike alternative libraries, when an image download is complete, Snrlax ensures the ImageView still wants the same image it started with. This makes Snrlax the ideal library for image displaying within `UITableView`s.

```swift
let IMAGE_URL = "https://static1.squarespace.com/static/5563f674e4b024c2e33e24e5/576fb637b3db2bd35f665512/576fb64bff7c50a6aeabf726/1466938964385/Globs.jpg?format=1500w"
                
Snrlax.shared.media_manager.pull(endpoint: IMAGE_URL, media_type: .image, image_view: image_view)
```

# Extension Libraries

While Snrlax will unequivocally remain a "no fluff" library for Swift Networking, additional components have been created to compliment the Snrlax ecosystem. These can additionally be included in your project, with specific instructions within each repository.

- [SnrlaxS3](https://github.com/rwolande/SnrlaxS3) - An AWS S3-focused library that extends media management to support S3 buckets.
- [SnrlaxUI](https://github.com/rwolande/SnrlaxUI) - A User Interface library that extends UIKit staples to optionally bind with data, while also providing elegant widgets for image, gif, & video media.

# Communication

<!-- - If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/snrlax). (Tag 'snrlax') -->
<!-- - If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/snrlax). -->
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

# Open Radars

There are currently no open radars for Snrlax! Good job guys!

# FAQ

>Where does the name come from?

`SNRLAX` is an acronym for **S**wift-**N**ative **R**EST-compliant **L**ibrary for **A**synchronous **T**ransactions. We also couldn't resist the play on words with REST.

# Credits

Snrlax is created and maintained by [Ryan Wolande & Friends](http://ryanwolande.com). You can follow the development cycle on Twitter at [@SnrlaxSwift](https://twitter.com/SnrlaxSwift) for project updates and releases. Feel free to tweet at us for feedback, requests, or to bring attention to anything else involving the Snrlax library.

## Security Disclosure

If you believe you have identified a security vulnerability with Snrlax, you should report it as soon as possible via email to security@snrlax.com. Please do not post it to a public issue tracker.

# License

Snrlax is released under the MIT license. [See LICENSE](https://github.com/rwolande/Snrlax/blob/master/LICENSE.md) for details.
