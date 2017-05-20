![Snrlax: Simple, Fluff-less, Swift Networking](https://s-media-cache-ak0.pinimg.com/236x/36/e8/6f/36e86ffe87d0a3b0348461b9650768ed.jpg?noindex=1)

# SNRLAX
Swift-Native REST-compliant Library for Asynchronous Transactions

[![Twitter](https://img.shields.io/badge/twitter-@SnrlaxSwift-blue.svg?style=flat)](http://twitter.com/SnrlaxSwift)

<!-- [![Build Status](https://travis-ci.org/rwolande/Snrlax.svg?branch=master)](https://travis-ci.org/rwolande/Snrlax)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Alamofire.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/Alamofire.svg?style=flat)](http://cocoadocs.org/docsets/Alamofire)-->

Snrlax is _the_ leanest HTTP(S) networking library for iOS. Written entirely in Swift, Snrlax makes it wildly easy to securely exchange information with any remote API. 

- [Features](#features)
- [Extension Libraries](#extension-libraries)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
    - **Intro -** [Configuration](#configuration), [Making a Request](#making-a-request), [QueryDelegate](#querydelegate), [QueryDataSource](#querydatasource)
	- **HTTP -** [HTTP Methods](#http-methods), [Parameter Encoding](#parameter-encoding), [HTTP Headers](#http-headers), [Authentication](#authentication)
	- **Large Data -** [Downloading Data to a File](#downloading-data-to-a-file), [Uploading Data to a Server](#uploading-data-to-a-server)
	- **Tools -** [Statistical Metrics](#statistical-metrics), [cURL Command Output](#curl-command-output)
- [Advanced Usage](#advanced-usage)
	- **URL Session -** [Session Manager](#session-manager), [Session Delegate](#session-delegate), [Request](#request)
	- **Routing -** [Routing Requests](#routing-requests), [Adapting and Retrying Requests](#adapting-and-retrying-requests)
	- **Model Objects -** [Custom Response Serialization](#custom-response-serialization)
	- **Connection -** [Security](#security), [Network Reachability](#network-reachability)
- [Open Radars](#open-radars)
- [FAQ](#faq)
- [Credits](#credits)
- [Donations](#donations)
- [License](#license)

## Features

- [x] HTTP Secure by Default 
- [x] Download File using Request; optimized for Images and Video
<!-- - [x] Download File using Request or Resume Data -->
- [x] Swifty Protocols for variant responses (as opposed to single closures)
- [ ] Chainable Request / Response Methods (Coming)
- [ ] Upload File / Data / Stream / MultipartFormData (Coming)
- [x] Authentication with URLCredential
- [x] HTTP Response Code Validation by Default
- [x] Network Activity Indicator Management by Default
- [ ] Upload and Download Progress Closures with Progress
- [ ] Dynamically Adapt and Retry Requests
- [ ] TLS Certificate and Public Key Pinning
- [ ] Network Reachability
- [ ] Comprehensive Unit and Integration Test Coverage
- [ ] User Interface Bindings
-- [x] UIImageView
-- [ ] UITableView
-- [ ] SnrlaxVideoView
- [ ] [Complete Documentation](http://cocoadocs.org/docsets/Snrlax)

## Extension Libraries

To keep Snrlax as the leanest and easiest-to-learn library for Swift Networking, additional component libraries have been created to bring additional functionality to your ecosystem, specifically for AWS users.

- [SnrlaxS3](https://github.com/rwolande/SnrlaxS3) - An AWS S3-focused library that extends media management to support S3 buckets.

## Requirements

- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+

## Communication

<!-- - If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/snrlax). (Tag 'snrlax') -->
<!-- - If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/snrlax). -->
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### CocoaPods

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

### Carthage

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

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. Be aware that the Swift Package Manager is in early development; this said, Snrlax does support its use on supported platforms.

Once you have your Swift package set up, adding Snrlax as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/rwolande/Snrlax.git", majorVersion: 0)
]
```

#### Embedded Framework

- Due to the nature of a Snrlax being a quick and nimble networking library, we anticipate many developers using Snrlax as they learn Swift. Due to the nuances and bloat of embedded frameworks, we strongly discourage their use in general and ask only professionals consider their use with Snrlax.

---

## Usage

### Configuration

A singleton for Snrlax will be your primary instance
```swift
Snrlax.shared
```

It can be configured by assigning an instane of SnrlaxServiceConfiguration
```swift
let YOUR_HOST_DOMAIN = "api.snrlax.com/"
Snrlax.shared.configuration = SnrlaxServiceConfiguration(host: YOUR_HOST_DOMAIN)
```
-- HTTPS will be assumed. We encourage you to use SSL (HTTPS) for all data transfers. In the event you must use an unecrypted connection, you can turn SSL off in your configuration

```swift
Snrlax.shared.configuration!.ssl = false //Will make HTTP://YOUR_HOST requests
```

### Making a Request
#### Response Management
##### QueryDelegate

One of the many advantages of Snrlax is it's rather Swifty response management. Following Apple's lead, Snrlax opts to use delegatation (protocol inheritance) over closures for response management. Any class which will process and parse a JSON result must conform to the QueryDelegate protocol. Note, both QueryDelegate functions are optional so the following will compile.


```swift
class ViewController: UIViewController, QueryDelegate {
}
```

###### QueryDelegate Methods
A much more practical implementation:
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

#### Passing Body Data
##### QueryDataSource

Oftentimes, you'll want to include custom paramaters with your request. This is where Snrlax shines, both with it's Swifty signatures and it's dynamic overloading ability. A class which conforms to QueryDataSource can optionally implement a 'body()' function to return custom parameters.


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

Including the data_source parameter:
```swift
class ViewController: UIViewController, QueryDelegate
{

        override func viewDidLoad()
        {
                super.viewDidLoad()
                
                let endpoint = SnrlaxEndpoint(literal: "user/2") //Domain-specific route
                Snrlax.shared.request(endpoint: endpoint, parser_delegate: self, data_source: self) //data_source -> QueryDataSource
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

#### Default Body Data

We encourage Snrlax users to create a pair of custom classes to conform to QueryDelegate and QueryDataSource.


#### Default Body Data
In the case you consistently provide default body parameters, Snrlax offers a boiler-plate minimal solution by always including a body when Snrlax.shared.global_data_source is set.
-In the event you pass a data_source to the request() method, both bodies will be included as one combined body. If there is a key collision, the passed QueryDataSource will take precedence over the global QueryDataSource.


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

#### Default Response Delegate
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

### Response Handling

Handling the `Response` of a `Request` made in Snrlax is straight forward. All keys from your API will be root-keys of the body map passed in successful_query().
-In the event an array is returned from your API, the body will have 1-root key: "data", which will map to your array values.
-In the event a single key is passed which is either:
--data
--body
--result
The key will be disregarded and the underlying data will be found at the root level. This minimizes much of the 'Swift Optional Dance' which also keeping your data concise and most easily processed.

#### Add examples

<!-- In the above example, the `responseJSON` handler is appended to the `Request` to be executed once the `Request` is complete. Rather than blocking execution to wait for a response from the server, a [callback](http://en.wikipedia.org/wiki/Callback_%28computer_programming%29) in the form of a closure is specified to handle the response once it's received. The result of a request is only available inside the scope of a response closure. Any execution contingent on the response or data received from the server must be done within a response closure.-->

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
#Case 1

let USER_ROUTE = "user"
let endpoint = SnrlaxEndpoint(literal: USER_ROUTE + "/2") //Method defauls to get
Snrlax.shared.request(endpoint: endpoint)

#Case 2
let endpoint = SnrlaxEndpoint(literal: USER_ROUTE + "/2", method: .GET) //Same as above
Snrlax.shared.request(endpoint: endpoint)

Case 3
let endpoint = SnrlaxEndpoint(literal: USER_ROUTE, method: .POST) //Post method will be used
Snrlax.shared.request(endpoint: endpoint)
```

This allows common RESTful practices to be mirrored in Swift. Routes can be recycled with different appendments (as seen above) and also with different methods.

> The `SnrlaxEndpoint.rest_method` parameter defaults to `.get`.

## Credits

Snrlax is created and maintained by Ryan Wolande & Friends [Ryan Wolande & Friends](http://ryanwolande.com). You can follow the development cycle on Twitter at [@SnrlaxSwift](https://twitter.com/SnrlaxSwift) for project updates, releases, and of course feel free to tweet at us for feedback, requests, or to bring attention to anything else involving the Snrlax library.

### Security Disclosure

If you believe you have identified a security vulnerability with Snrlax, you should report it as soon as possible via email to security@snrlax.com. Please do not post it to a public issue tracker.

## License

Snrlax is released under the MIT license. [See LICENSE](https://github.com/rwolande/Snrlax/blob/master/LICENSE.md) for details.
