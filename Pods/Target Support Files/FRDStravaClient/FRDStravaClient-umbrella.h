#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FRDStravaClient+Access.h"
#import "FRDStravaClient+Activity.h"
#import "FRDStravaClient+ActivityStream.h"
#import "FRDStravaClient+Athlete.h"
#import "FRDStravaClient+Club.h"
#import "FRDStravaClient+Gear.h"
#import "FRDStravaClient+Lap.h"
#import "FRDStravaClient+Segment.h"
#import "FRDStravaClient+Upload.h"
#import "FRDStravaClient.h"
#import "FRDStravaClientImports.h"
#import "StravaAccessTokenResponse.h"
#import "StravaActivity.h"
#import "StravaActivityComment.h"
#import "StravaActivityLap.h"
#import "StravaActivityPhoto.h"
#import "StravaActivityUploadStatus.h"
#import "StravaActivityZone.h"
#import "StravaAthlete.h"
#import "StravaClub.h"
#import "StravaCommon.h"
#import "StravaGear.h"
#import "StravaMap.h"
#import "StravaSegment.h"
#import "StravaSegmentEffort.h"
#import "StravaStream.h"

FOUNDATION_EXPORT double FRDStravaClientVersionNumber;
FOUNDATION_EXPORT const unsigned char FRDStravaClientVersionString[];

