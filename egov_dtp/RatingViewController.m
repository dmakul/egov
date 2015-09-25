#import <ChameleonFramework/Chameleon.h>
#import "RatingViewController.h"
#import "UIColor+Helpers.h"
#import "Macros.h"
#import "SubMenuTableViewCell.h"


@interface RatingViewController () <UITableViewDataSource,UITableViewDelegate>
@property UITableView *tableView;
@property NSMutableArray *districts;
@end
@implementation RatingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScreen];
    [self setUpTableView];
    self.title = @"Рейтинг";
}
- (void)setUpScreen {
    [self.view setBackgroundColor:[UIColor colorFromHexString:MainColor]];
}
#pragma mark
#pragma - TableView methods
-(void)setUpTableView {
    
    self.districts = [NSMutableArray arrayWithObjects:@"Ауезовский район", @"Бостандыкский район", @"Медеуский район", @"Алмалинский район", @"Жетысуский район", @"Турксибский район", nil];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = nil;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80.f;
    self.tableView.tableFooterView = [UIView new];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.districts count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[SubMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.nameLabel.text = self.districts[indexPath.row];
    if (indexPath.row == 0) {
        cell.image.backgroundColor = [UIColor flatYellowColor];
        cell.priceLabel.text = @"1321 аварий";
    } else if (indexPath.row == 2) {
        cell.image.backgroundColor = [UIColor flatMintColor];
        cell.priceLabel.text = @"977 аварий";
    } else if (indexPath.row == 3) {
        cell.image.backgroundColor = [UIColor flatRedColor];
        cell.priceLabel.text = @"1675 аварий";
    } else if (indexPath.row == 5) {
        cell.image.backgroundColor = [UIColor flatYellowColor];
        cell.priceLabel.text = @"1102 аварий";
    } else if (indexPath.row == 4) {
        cell.image.backgroundColor = [UIColor flatMintColor];
        cell.priceLabel.text = @"867 аварий";
    } else if (indexPath.row == 1) {
        cell.image.backgroundColor = [UIColor flatRedColor];
        cell.priceLabel.text = @"1596 аварий";
    }
    return cell;
}
@end