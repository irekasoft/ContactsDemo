//
//  GroupsTVC.h
//  FavoritesContact
//
//  Created by Hijazi on 6/3/16.
//  Copyright © 2016 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Contacts;
@import ContactsUI;

@interface GroupsTVC : UITableViewController{
  
  NSArray *groups;
  
}

@property (strong) CNContactStore *contactStore;

@end
