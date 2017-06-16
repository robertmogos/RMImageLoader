# RMImageLoader


RMImageLoader is a library for background image-loading. 

## Features

- Background image-loading
- Download cancelation
- Caching in memory and on disk
- Extension for UIImageView

## Description

 RMImageLoader allows you to download asynchronously images. In order to improve and avoid the number of connection, each image that it is being downloaded can have multiple subscribers. A subscriber is an **AnyObject** that is interested in the image. This way, you avoid downloading the same image several times. The download can't be canceled  unless all the subcribers decided not to download it anymore. Otherwise, any subscriber that cancels it, will just be ignored when the download is ready.

## Usage

###
```swift
import RMImageLoader
```


### Loading images

#### Requesting an image for a UIImageView

```swift
RMImageLoader.default.loadImage(url: yourUrl, subscriber: imageView, success: { image in
  imageView.image = image
}, failure: { _ in
  print("ouch")
})
```

or even faster

```swift
imageView.load(url: yourUrl)
```

#### Cancel a request

```swift
imageView.cancel(url: yourUrl)
```

or 

```swift
RMImageLoader.default.cancel(url: yourUrl, forSubscriber: imageView)
```

### Custom usage

### RMImageLoader
  
The default configuration can be used which will use the Retriever to download the images but any can be initialized with any class that implements the **Retrieve** protocol

### Retriever

The default implementation is using an NSCache to store the processed data:
- 100 MB disk space
- 20 MB memory space

You can inject your own **URLSessionConfiguration**
