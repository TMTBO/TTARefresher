# TTARefresher

**A easy way to pull to refresh, Thanks for [MJRefresh](https://github.com/CoderMJLee/MJRefresh)**

[![CI Status][image-1]][1]
[![Version][image-2]][2]
[![License][image-3]][3]
[![Platform][image-4]][4]

## Contents

[Example](#Example)

[Requirements](#Requirements)

[Installation](#Installation)

[File Structures](#File Structures)

[Api](#Api)

* [Name Space](#Name Space)

* [Refresher States](#Refresher States)

* [TTARefresherComponent](#TTARefresherComponent)

* [TTARefresherStateHeader](#TTARefresherStateHeader)	
* [TTARefresherFooter](#TTARefresherFooter)

* [TTARefresherAutoFooter](#TTARefresherAutoFooter)

* [TTARefresherBackFooter](#TTARefresherBackFooter)

* [TTARefresherAutoStateFoote](#TTARefresherAutoStateFoote)

* [TTARefresherBackStateFooter](#TTARefresherBackStateFooter)

* [TTARefresherAutoNormalFooter](#TTARefresherAutoNormalFooter)

* [TTARefresherBackNormalFooter](#TTARefresherBackNormalFooter)

* [TTARefresherNormalHeader](#TTARefresherNormalHeader)

* [TTARefresherAutoGifFooter](#TTARefresherAutoGifFooter)

* [TTARefresherBackGifFooter](#TTARefresherBackGifFooter)

* [TTARefresherGifHeader](#TTARefresherGifHeader)

* [Header](#Header)

* [Footer](#Footer)

[How to use ](#How to use )

[Author](#Author)

[License](#License)

## <a name="Example"></a>Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## <a name="Requirements"></a>Requirements

* iOS >= 8.3
* Swift >= 3.0

## <a name="Installation"></a>Installation
*  TTARefresher is available through [CocoaPods][5]. To install
it, simply add the following line to your Podfile:`pod "TTARefresher"`

*  Manual import：

	Drag All files in the MJRefresh folder to project, import the main file：`import TTARefresher`

## <a name="File Structures"></a>File Structures

		TTARefresherComponent
			|
			|- TTARefresherHeader
			|		|
			|		|- TTARefresherStateHeader
			|				|
			|				|- TTARefresherNormalHeader (DIRECTLY USE)
			|				|
			|				|- TTARefresherGifHeader (DIRECTLY USE)
			|
			|- TTARefresherFooter
					|
					|- TTARefresherAutoFooter
					|		|
					|		|- TTARefresherAutoStateFoote
					|				|
					|				|- TTARefresherAutoNormalFooter (DIRECTLY USE)
					|				|
					|				|- TTARefresherAutoGifFooter (DIRECTLY USE)
					|
					|- TTARefresherBackFooter
							|
							|- TTARefresherBackStateFoote
									|
									|- TTARefresherBackNormalFooter (DIRECTLY USE)
									|
									|- TTARefresherBackGifFooter (DIRECTLY USE)
	 
## <a name="Api"></a>Api

**<a name="Name Space"></a>Name Space**

    /// For the Instance Methods
    public var ttaRefresher: TTARefresher.TTARefresherProxy<Self>
	
	// /For the Static Methods
    public static var TTARefresher: TTARefresher.TTARefresherProxy<Self>.Type 
    
	/// Refresher Header    
    public var header: TTARefresher.TTARefresherHeader?
	
	/// Refresher Footer
    public var footer: TTARefresher.TTARefresherFooter?
    
    /// Data Count in total
    public var totalDataCount: Int

**<a name="Refresher States"></a>Refresher States**

		public enum TTARefresherState : Int {
			/// Normal State
		    case idle

		    case pulling

		    case refreshing

		    case willRefresh
		    
		    case noMoreData
		}

**<a name="TTARefresherComponent"></a>TTARefresherComponent**

		/// Refresher State
		open var state: TTARefresher.TTARefresherState
		
		/// Whether the Refresher is Refreshing
		public var isRefreshing: Bool
		
		/// Current pulling Percentage
   		open var pullingPercent: CGFloat
		
		/// Whether Auto Change the Refresher Alpha
		public var isAutoChangeAlpha: Bool

    	/// The Refresher's superView, Readonly for subviews
    	public fileprivate(set) var scrollView: UIScrollView?

    	/// The ScrollView Original inset, Readonly for subviews
    	public internal(set) var scrollViewOriginalInset: UIEdgeInsets
    	
    	/// Refresher Targer
    	public var refreshingTarget: AnyObject?
		
		/// Refresher Action
    	public var refreshingAction: Selector?
		
		/// Refresher Handler
    	public var refreshingHandler: TTARefresher.TTARefresherComponentRefreshingHandler?
    	
		/// Excuate While Begin Refreshing Completed
    	public var beginRefreshingCompletionHandler: TTARefresher.TTARefresherComponentBeginCompletionHandler?
		
		/// Excuate While End Refreshing Completed
    	public var endRefreshingCompletionHandler: TTARefresher.TTARefresherComponentEndCompletionHandler?

    	/// Set Refreshing Target and Action
    	public func setRefreshingTarget(aTarget: AnyObject, anAction: Selector)
	
		/// Begin Refreshing
    	public func beginRefreshing(_ completionHandler: TTARefresher.TTARefresherComponentBeginCompletionHandler? = default)
    	
		/// End Refreshing
    	public func endRefreshing(_ completionHandler: TTARefresher.TTARefresherComponentEndCompletionHandler? = default)
    	

**<a name="TTARefresherStateHeader"></a>TTARefresherStateHeader**  	

		/// Refresher Header State Label
		lazy public var stateLabel: UILabel
		
		/// Refresher Header Time Label
		public var lastUpdatedTimeLabel: UILabel

    	/// The margin between Label and left images
    	public var labelLeftInset: CGFloat
		
		/// Set Custom Titles for State
		public func set(title: String, for state: TTARefresher.TTARefresherState)
		
**<a name="TTARefresherFooter"></a>TTARefresherFooter**
   	
    	/// If true, the footer will be shown when there are data, otherwise, footer will be hidden
    public var isAutoHidden: Bool
	
		/// The ContentInset Bottom to ignore
    	public var ignoredScrollViewContentInsetBottom: CGFloat
    	
    	/// Rest Refresher state `.noMoreData` to `.idle`
    	public func resetNoMoreData()
    	
    	/// End Refresher and Set State With `.noMoreData`
    	public func endRefreshWithNoMoreData()

**<a name="TTARefresherAutoFooter"></a><a name="TTARefresherBackFooter"></a>TTARefresherAutoFooter & TTARefresherBackFooter**

		/// Whether Footer Auto Refresh
		public var isAutoRefresh: Bool
		
		/// The percent when the footer appear will get refresh, default is 1.0
    	public var triggerAutoRefreshPercent: CGFloat
    	
    	/// Whether Hide Footer
    	open var isHidden: Bool
   
**<a name="TTARefresherAutoStateFoote"></a><a name="TTARefresherBackStateFooter"></a>TTARefresherAutoStateFoote & TTARefresherBackStateFooter** 
	
		/// State Label
		open var stateLabel: UILabel
		
		/// Set Custom Titles for state
		public func set(title: String, for state: TTARefresher.TTARefresherState)
		
		/// Title for state
		public func title(for state: TTARefresher.TTARefresherState) -> String?
    	
**<a name="TTARefresherAutoNormalFooter"></a><a name="TTARefresherBackNormalFooter"></a><a name="TTARefresherNormalHeader"></a>TTARefresherAutoNormalFooter & TTARefresherBackNormalFooter & TTARefresherNormalHeader**
	
		/// Refresher Footer/ Header Indicator Style, default is `.gray`
		public var indicatorStyle: UIActivityIndicatorViewStyle
		
		/// Back Normal Footer's Arrow Image View
		public var arrowImageView: UIImageView
		
**<a name="TTARefresherAutoGifFooter"></a><a name="TTARefresherBackGifFooter"></a><a name="TTARefresherGifHeader"></a>TTARefresherAutoGifFooter & TTARefresherBackGifFooter & TTARefresherGifHeader**
		
		/// Gif Image View
		open var gifImageView: UIImageView
		
		/// Set Images And Animation Time for State
		public func set(images: [UIImage]?, duration: TimeInterval?, for state: TTARefresher.TTARefresherState)
	
		/// Set Images For State, Default Time is `images.count * 0.1`
    	public func set(images: [UIImage]?, for state: TTARefresher.TTARefresherState)

		

```

extension TTARefresherComponent {

    open func prepare()

    open func placeSubviews()

    open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?)

    open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?)

    open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?)
}

```

## <a name="How to use"></a>How to use 
	 
### <a name="Header"></a>Header
---- 
#### <a name="Default Header"></a>Default Header

	    let header = TTARefresherNormalHeader {
	        self.loadNew()
	    }
	   // or
	   let header = TTARefresherNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
![Default Header][image-5]

#### <a name="Gif Header"></a>Gif Header

	    let header = TTARefresherGifHeader {
	        self.loadNew()
	    }
	   // or
	    let header = TTARefresherGifHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
	   // The margin between label and images
	   header.labelLeftInset = 10
	   let (idleImages, refreshingImages) = prepareAnimationImages()
	   header.set(images: idleImages, for: .idle)
	   header.set(images: refreshingImages, for: .refreshing)
![Gif Header][image-6]

#### <a name="Header Hide Time"></a>Header Hide Time

	    header.lastUpdatedTimeLabel.isHidden = true

![Header Hide Time][image-7]


#### <a name="Header Hide Time And State"></a>Header Hide Time And State
	 
	    header.stateLabel.isHidden = true
	    header.lastUpdatedTimeLabel.isHidden = true
		 
![Header Hide Time And State][image-8]
		 
#### <a name="Header Custom Text"></a>Header Custom Text

	    header.set(title: "Pull Me Down", for: .idle)
	    header.set(title: "Release Me To Refresh", for: .pulling)
	    header.set(title: "Come on, I'm getting the data", for: .refreshing)
		 
![Header Hide Time And State][image-9]
	 
### <a name="Footer"></a>Footer

---- 

#### <a name="Footer Default Auto"></a>Footer Default Auto

	    let footer = TTARefresherAutoNormalFooter {
	        self.loadMore()
	    }
	   // or
	   let footer  = TTARefresherAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(endLoadMore))

![Footer Default Auto](/gif/TTARefresher_default_auto_footer.gif)

#### <a name="Auto Gif Footer"></a>Auto Gif Footer

	    let footer = TTARefresherAutoGifFooter {
	        self.loadMore()
	    }
	   // or
	    let footer = TTARefresherAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
	    let (idleImages, refreshingImages) = prepareAnimationImages()
	    footer.set(images: idleImages, for: .idle)
	    footer.set(images: refreshingImages, for: .refreshing)
	    
![Auto Gif Footer](https://github.com/TMTBO/TTARefresher/blob/master/gif/TTARefresher_default_auto_gif_footer.gif)


#### <a name="Back Footer"></a>Back Footer

		let footer = TTARefresherBackNormalFooter {
            self.loadMore()
        }
        // or
	    let footer = TTARefresherBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))

![Back Footer](https://github.com/TMTBO/TTARefresher/blob/master/gif/TTARefresher_default_back_footer.gif)

#### <a name="Auto Gif Hide State"></a>Auto Gif Hide State

		footer.stateLabel.isHidden = true
		
![Auto Gif Hide State](https://github.com/TMTBO/TTARefresher/blob/master/gif/TTARefresher_default_auto_gif_footer_hide_state.gif)

---- 

## <a name="Author"></a>Author

TMTBO, tmtbo@hotmail.com

## <a name="License"></a>License

TTARefresher is available under the MIT license. See the LICENSE file for more info.

[1]:	https://travis-ci.org/TMTBO/TTARefresher
[2]:	http://cocoapods.org/pods/TTARefresher
[3]:	http://cocoapods.org/pods/TTARefresher
[4]:	http://cocoapods.org/pods/TTARefresher
[5]:	http://cocoapods.org

[image-1]:	http://img.shields.io/travis/TMTBO/TTARefresher.svg?style=flat
[image-2]:	https://img.shields.io/cocoapods/v/TTARefresher.svg?style=flat
[image-3]:	https://img.shields.io/cocoapods/l/TTARefresher.svg?style=flat
[image-4]:	https://img.shields.io/cocoapods/p/TTARefresher.svg?style=flat
[image-5]:	https://github.com/TMTBO/TTARefresher/blob/master****/gif/TTARefresher_default_header.gif
[image-6]:	https://github.com/TMTBO/TTARefresher/blob/master/gif/TTARefresher_gif_header.gif
[image-7]:	https://github.com/TMTBO/TTARefresher/blob/master/gif/TTARefresher_default_header_hide_time_lable.gif
[image-8]:	https://github.com/TMTBO/TTARefresher/blob/master/gif/TTARefresher_gif_header_hide_time_and_state.gif
[image-9]:	https://github.com/TMTBO/TTARefresher/blob/master/gif/TTARefresher_default_header_custom_text.gif
