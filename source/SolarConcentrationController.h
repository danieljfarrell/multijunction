#import <Cocoa/Cocoa.h>

@interface NSObjectController : NSController {
    IBOutlet id content;
    IBOutlet NSManagedObjectContext *managedObjectContext;
}
- (IBAction)add:(id)sender;
- (IBAction)fetch:(id)sender;
- (IBAction)remove:(id)sender;
@end
