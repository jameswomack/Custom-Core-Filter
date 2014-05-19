# Custom Core Filters
## Mac

If you :heart: Quartz Composer &/or CoreFilters the way I do, you've already built a suite of CoreFilter manipulations that you can apply to your photos. 

Custom Core Filters is a repo design to show you how you can utilize this API with your own CoreFilters:
```
MYFilter *filter = (MYFilter *)[CoreFilter filterWithName:MY_FILTER_NAME];
[filter setValue:self.imageView.image.CIImage forKey:kCIInputImageKey];
[filter setDefaults];
self.imageView.image = filter.outputNSImage;
```