//
//  ContactsTVC.h
//  FavoritesContact
//
//  Created by Hijazi on 6/3/16.
//  Copyright © 2016 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Boldify.h"
@import Contacts;
@import ContactsUI;

@interface ContactsTVC : UITableViewController {
  
  NSArray *contacts;
  NSArray *groups;
  NSArray *containers;
  
}

@property (strong) CNContactStore *contactStore;

@end
