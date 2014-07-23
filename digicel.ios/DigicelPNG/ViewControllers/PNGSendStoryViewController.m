//
//  PNGSendStoryViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGSendStoryViewController.h"
#import "PNGSendStoryWebService.h"
#import "PNGStory.h"
#import "PNGFile.h"
#import "PNGArticle.h"

#define THUMBIMAGE_WIDTH 70.0f
#define THUMBIMAGE_HEIGHT 70.0f
#define CLOSEBUTTON_WIDTH 25.0f
#define CLOSEBUTTON_HEIGHT 25.0f
#define CLOSEBUTTON_INITIAL_Y -2.0f
#define CLOSEBUTTON_X_OFFSET 51.0f
#define THUMBNAILS_SPACING 6
#define SCROLLVIEW_LEFT_SPACING 12
#define OFFSET_VALUE 85
#define INITIAL_POINT 5
#define VIDEO_DURATION 10
#define MEDIA_GALLERY 0
#define CAPTURE_PHOTO 1
#define CAPTURE_VIDEO 2



@interface PNGSendStoryViewController () {
    NSMutableArray *mediaArray;
    NSMutableArray *thumbNailArray;
    UIImagePickerController *pickercontroller;
}

@property (weak, nonatomic) IBOutlet UITextView *storyTextField;
@property (weak, nonatomic) IBOutlet UILabel *storyValidationLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PNGSendStoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Send Story";
    [self initialiseViewParameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - IBActions

- (IBAction)attachMedia:(id)sender {
    
    //Actionsheet displayed on attach media action
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: NSLocalizedString(@"CANCEL", @"")
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: NSLocalizedString(@"CHOOSE_FROM_GALLERY", @""), NSLocalizedString(@"TAKE_PHOTO", @""), NSLocalizedString(@"TAKE_VIDEO", @""),   nil];
    [actionSheet showInView:self.view];
}

- (IBAction)sendArticle:(id)sender {
    //send article
    if ([self isValid]) {
        [self.view endEditing:YES];
       // [self getStoryObject];// to Parse
        [self callSendStoryWebService]; // to wp
        
    }
}

- (IBAction)thumbNailImageTapped:(id)sender {
    //remove video or image on tapping the thumbnail
    UIButton *button = (UIButton *)sender;
    for (UIView *subview in self.scrollView.subviews) {
        if (subview.tag == button.tag) {
            [subview removeFromSuperview];
        }
    }
    [thumbNailArray removeObjectAtIndex:button.tag];
    [mediaArray removeObjectAtIndex:button.tag];
    [self addMediaThumbNailImages];
}

#pragma mark - Private Methods

- (BOOL)isValid {
    //Check if the description field is not empty
    BOOL isValid = NO;
    if (![self.storyTextField.text isEqualToString:NULL_STRING]) {
        isValid = YES;
    }
    return isValid;
}

- (void)initialiseViewParameters {
    [self.storyTextField becomeFirstResponder];
    mediaArray = [[NSMutableArray alloc] init];
    thumbNailArray = [[NSMutableArray alloc] init];
}

- (void)initialiseImagePicker:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes {
    //initialise image picker
    pickercontroller = [[UIImagePickerController alloc] init];
    pickercontroller.sourceType = sourceType;
    pickercontroller.allowsEditing = NO;
    pickercontroller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: sourceType];
    pickercontroller.delegate = self;
    [self presentViewController:pickercontroller animated:YES completion: nil];
}

- (void)capturePhoto {
    //take photo using device camera
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [self initialiseImagePicker:UIImagePickerControllerSourceTypeCamera mediaTypes:[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]];
    }
}

- (void)chooseMediaFromGallery {
    //choose photo or video from gallery
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSArray *mediaTypesArray = @[(NSString *) kUTTypeImage,
                                     (NSString *) kUTTypeMovie];
        [self initialiseImagePicker:UIImagePickerControllerSourceTypePhotoLibrary mediaTypes:mediaTypesArray];
    }
}

- (void)captureVideo {
    //capture new video for upload
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        pickercontroller = [[UIImagePickerController alloc]init];
        NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:pickercontroller.sourceType];
        if (![sourceTypes containsObject:(NSString*)kUTTypeMovie] ) {
            [[[UIAlertView alloc] initWithTitle:NULL_STRING message:NSLocalizedString(@"NO_VIDEO_SUPPORT", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        pickercontroller.allowsEditing = YES;
        pickercontroller.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickercontroller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        pickercontroller.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
        pickercontroller.videoQuality = UIImagePickerControllerQualityTypeMedium;
        pickercontroller.videoMaximumDuration = VIDEO_DURATION;
        pickercontroller.delegate = self;
        [self presentViewController:pickercontroller animated:YES completion:nil];
    }
}

- (void)addMediaThumbNailImages {
    //add thumbnail images to scrollView horizontally with spacing
    for (UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
    for (int index = 0; index < [thumbNailArray count]; index ++) {
        UIImageView *thumbNailImageView = [[UIImageView alloc] init];
        CGFloat xValue = ((index*THUMBIMAGE_WIDTH) + (THUMBNAILS_SPACING*index) + SCROLLVIEW_LEFT_SPACING);
        [thumbNailImageView setFrame:CGRectMake(xValue, INITIAL_POINT, THUMBIMAGE_WIDTH, THUMBIMAGE_HEIGHT)];
        [thumbNailImageView setImage:[thumbNailArray objectAtIndex:index]];
        [thumbNailImageView setTag:index];
        [self.scrollView addSubview:thumbNailImageView];
        [self.scrollView setContentSize:CGSizeMake((xValue + OFFSET_VALUE), THUMBIMAGE_HEIGHT)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(xValue, INITIAL_POINT, THUMBIMAGE_WIDTH, THUMBIMAGE_HEIGHT)];
        [button setTag:index];
        if (![[mediaArray objectAtIndex:index] isKindOfClass:[UIImage class]]) {
            [button setImage:[UIImage imageNamed:PNGStoryboardImagePlayVideo] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(thumbNailImageTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(xValue + CLOSEBUTTON_X_OFFSET, CLOSEBUTTON_INITIAL_Y , CLOSEBUTTON_WIDTH, CLOSEBUTTON_HEIGHT)];
        [closeButton setTag:index];
        [closeButton setImage:[UIImage imageNamed:PNGStoryboardImageRemoveMedia] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(thumbNailImageTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:closeButton];
    }
}

- (void)getStoryObject {
    //create PNGStory object
    PNGStory *story = [[PNGStory alloc] init];
    story.description = self.storyTextField.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *filesArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < [mediaArray count]; index ++) {
        NSData *fileData;
        NSString *fileType;
        PFFile *file;
        if ([[mediaArray objectAtIndex:index] isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)[mediaArray objectAtIndex:index];
            fileData= UIImageJPEGRepresentation(image, 0.0);
            fileType = IMAGE_TYPE;
            file = [PFFile fileWithName:IMAGE_FILE_NAME data:fileData];
        } else {
            NSURL *videoUrl = (NSURL*)[mediaArray objectAtIndex:index];
            fileData = [NSData dataWithContentsOfURL:videoUrl];
            fileType = VIDEO_TYPE;
            file = [PFFile fileWithName:VIDEO_FILE_NAME data:fileData];
        }
        [file saveInBackground];
        PNGFile *pngFile = [[PNGFile alloc] init];
        pngFile.type = fileType;
        pngFile.file = file;
        [filesArray addObject:pngFile];
        [pngFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [PNGUtilities showAlertWithTitle:NULL_STRING message:NSLocalizedString(@"SERVER_ERROR", @"")];
            }
        }];
    }
    story.media = filesArray;
    [story saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.storyTextField.text = NULL_STRING;
            for (UIView *subview in self.scrollView.subviews) {
                [subview removeFromSuperview];
            }
            [PNGUtilities showAlertWithTitle:NULL_STRING message:NSLocalizedString(@"SAVE_SUCCESS", @"")];
        } else {
            [PNGUtilities showAlertWithTitle:NULL_STRING message:NSLocalizedString(@"SERVER_ERROR", @"")];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Send Story webservice methods

- (void)callSendStoryWebService {
    
    PNGSendStoryWebService *sendStoryWebService = [[PNGSendStoryWebService alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *type;
    NSData *mediaData;
    NSMutableArray *attachments = [[NSMutableArray alloc] init];
    if (mediaArray.count > 0) {
        for (int i = 0; i < mediaArray.count; i++) {
            NSMutableDictionary *attachment = [[NSMutableDictionary alloc] init];
            if ([[mediaArray objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                //get the first image
                mediaData = [PNGUtilities getDataForImage:[mediaArray objectAtIndex:i]];
                type = IMAGE_TYPE;
            } else {
                mediaData = [PNGUtilities getDataForUrl:[mediaArray objectAtIndex:i]];
                type = VIDEO_TYPE;
            }
            [attachment setObject:mediaData forKey:DATA_KEY];
            [attachment setObject:type forKey:TYPE_KEY];
            [attachments addObject:attachment];
        }
    }
    
    [sendStoryWebService sendStory:_storyTextField.text withAttachment:attachments withType:type  requestSucceeded:^(PNGArticle *post) {
        // handle success condition here
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"SUCCESS", @"") message:NSLocalizedString(@"POST_CREATE_SUCCESS", @"")];
        _storyTextField.text = NULL_STRING;
        [mediaArray removeAllObjects];
        [thumbNailArray removeAllObjects];
        for (UIView *subview in self.scrollView.subviews) {
            [subview removeFromSuperview];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } requestFailed:^(NSString *errorMessage) {
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMessage];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


#pragma mark - Actionsheet Delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case MEDIA_GALLERY:
            [self chooseMediaFromGallery];
            break;
        case CAPTURE_PHOTO:
            [self capturePhoto];
            break;
        case CAPTURE_VIDEO:
            [self captureVideo];
            break;
        default:
            break;
    }
}

#pragma mark - ImagePickerController Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [pickercontroller dismissViewControllerAnimated: YES completion: nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    if ([mediaType isEqualToString:(NSString *)kUTTypeVideo] ||
        [mediaType isEqualToString:(NSString *)kUTTypeMovie]) { // mediatype is video
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        [mediaArray addObject:videoURL];
        UIImage *thumbImage = [PNGUtilities generateThumbNailImageForUrl:mediaUrl];
        [thumbNailArray addObject:thumbImage];
    } else { //mediatype is image
        UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
        UIImage *thumbImage = [PNGUtilities generateThumbNailForImage:image];
        [thumbNailArray addObject:thumbImage];
        [mediaArray addObject:image];
    }
    [self addMediaThumbNailImages];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {
    [pickercontroller dismissViewControllerAnimated: YES completion: nil];
}

@end
