//
//  ContactsTVC.m
//  FavoritesContact
//
//  Created by Hijazi on 6/3/16.
//  Copyright © 2016 iReka Soft. All rights reserved.
//

#import "ContactsTVC.h"
#import "Constants.h"

@interface ContactsTVC ()

@end

@implementation ContactsTVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = LSTR(@"CONTACTS");
  
  if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == true){
    
  }else{
    // should jump to settings
    
  }
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(new)];
  
  
  self.navigationItem.leftBarButtonItems = @[addButton];
  
  // access
  self.contactStore = [CNContactStore new];
  
  [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
    
    
    NSArray *keysToFetch = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                             [CNContactViewController descriptorForRequiredKeys]];
    
    //    contacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:nil];
    
    containers = [self.contactStore containersMatchingPredicate:nil error:nil];
    
    NSMutableArray *array = [NSMutableArray array];
    
    
    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:[self.contactStore defaultContainerIdentifier]];
    
    
    NSArray *groupContacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:nil];
    
    [array addObjectsFromArray:groupContacts];
    
    
    
    
    contacts = array;
    
    // GET FROM CONTAINERS
    
    
    containers = [self.contactStore containersMatchingPredicate:nil error:nil];
    
    //
    //    NSMutableArray *array = [NSMutableArray array];
    //
    //    for (CNContainer *container in containers) {
    //
    //      NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:container.identifier];
    //
    //
    //      NSArray *groupContacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:nil];
    //
    //      [array addObjectsFromArray:groupContacts];
    //      NSLog(@"contact %@",container.name);
    //
    //    }
    //
    //    contacts = array;
    
    // GET CONTACTS FROM GROUP
    //
    //    NSMutableArray *array = [NSMutableArray array];
    //
    //    groups = [self.contactStore groupsMatchingPredicate:nil error:nil];
    //    for (CNGroup *group in groups) {
    //
    //
    //      NSPredicate *predicate = [CNContact predicateForContactsInGroupWithIdentifier:group.identifier];
    //
    //      NSArray *groupContacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:@[CNContactGivenNameKey,[CNContactViewController descriptorForRequiredKeys]] error:nil];
    //
    //      [array addObjectsFromArray:groupContacts];
    //      NSLog(@"contact %@",group.name);
    //    }
    //
    //    contacts = array;
    
    NSLog(@"how many %d", contacts.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // do stuff with image
      [self.tableView reloadData];
    });
    
    
  }];
  
}

- (void)new{
  
}

- (void)addDummyContact{

  // CREATING NEW CONTACT
  CNMutableContact *contact = [[CNMutableContact alloc] init];
  
  contact.givenName = @"asdf";
  contact.familyName = @"aa";
  //  contact.imageData;
  
  // cnlabelvalue is used for muliplevalue for object
  
  CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:@"john@example.com"];
  CNLabeledValue *workEmail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:@"hijazi@irekasoft.com"];
  
  contact.emailAddresses = @[homeEmail, workEmail];
  
  CNLabeledValue *appUrl = [CNLabeledValue labeledValueWithLabel:CNLabelURLAddressHomePage value:@"http://hijazi.com"];
  
  CNLabeledValue *googleMapsURL = [CNLabeledValue labeledValueWithLabel:CNLabelURLAddressHomePage value:@"maps://hijazi.com"];
  
  contact.urlAddresses = @[appUrl,googleMapsURL];
  
  // phone number
  contact.phoneNumbers = @[[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"0163373081"]]];
  
  //  CNContact model like nsdictionary
  
  CNMutablePostalAddress *address = [CNMutablePostalAddress new];
  address.state = @"Selangor";
  
  NSDateComponents *birthday = [NSDateComponents new];
  birthday.day = 20;
  birthday.month = 11;
  birthday.year = 1987;
  
  contact.birthday = birthday;
  
  CNSaveRequest *saveRequest = [CNSaveRequest new];
  [saveRequest addContact:contact toContainerWithIdentifier:nil];
  
  [self.contactStore executeSaveRequest:saveRequest error:nil];
  
  //
  //  [saveRequest updateContact:contact];
  //  [contactStore executeSaveRequest:saveRequest error:nil];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  CNContact *contact = contacts[indexPath.row];
  
  NSString *fullName = [NSString stringWithFormat:@"%@ %@",contact.givenName, contact.familyName];
  
  
  cell.textLabel.text = fullName;
  [cell.textLabel boldSubstring:contact.givenName];
  

  
  @try {
    
    CNLabeledValue *labeledValue = [contact.phoneNumbers lastObject];
    CNPhoneNumber *phoneNumber = [labeledValue valueForKey:CNLabelPhoneNumberMobile];
    cell.detailTextLabel.text = [phoneNumber stringValue];
    
  }
  @catch (NSException *exception) {
    
  }
  

  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  CNContact *contact = contacts[indexPath.row];
  
  CNContactViewController *contactVC = [CNContactViewController viewControllerForContact:contact];
  contactVC.contactStore = self.contactStore;
  [self.navigationController pushViewController:contactVC animated:true];
  
  
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
