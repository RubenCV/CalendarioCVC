//
//  TableViewControllerContacto.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 3/26/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "TableViewControllerContacto.h"
#import "ContactoViewController.h"

@interface TableViewControllerContacto ()

@property (strong, nonatomic) NSArray *arrAdmDir;
@property (strong, nonatomic) NSArray *arrDesProVinc;
@property (strong, nonatomic) NSArray *arrEvaRetro;
@property (strong, nonatomic) NSArray *arrExpProf;
@property (strong, nonatomic) NSArray *arrInnovPlan;

@end

@implementation TableViewControllerContacto

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Cargamos los datos
    NSString *pathPlist;
    
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List AdmDir" ofType: @"plist"];
    self.arrAdmDir = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List DesProVinc" ofType: @"plist"];
    self.arrDesProVinc = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List EvaRetro" ofType: @"plist"];
    self.arrEvaRetro = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List ExpProf" ofType: @"plist"];
    self.arrExpProf = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List InnovPlan" ofType: @"plist"];
    self.arrInnovPlan = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    //Creamos los datos
    
    NSString *sectionTitle1 = @"Administración y Dirección";
    NSString *sectionTitle2 = @"Desarrollo Profesional y Vinculación";
    NSString *sectionTitle3 = @"Evaluación y Retroalimentación";
    NSString *sectionTitle4 = @"Experiencia Profesional";
    NSString *sectionTitle5 = @"Innovación y Planeación Estratégica";
    
    
    NSMutableArray *arrTmpEvaRetro = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.arrEvaRetro.count; i++){
        NSDictionary *object = self.arrEvaRetro[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [arrTmpEvaRetro addObject:tmp];
    }
    
    NSMutableArray *arrTmpDesProVinc = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.arrDesProVinc.count; i++){
        NSDictionary *object = self.arrDesProVinc[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [arrTmpDesProVinc addObject:tmp];
    }
    
    NSMutableArray *arrTmpAdmDir = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.arrAdmDir.count; i++){
        NSDictionary *object = self.arrAdmDir[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [arrTmpAdmDir addObject:tmp];
    }
    
    NSMutableArray *arrTmpExpProf = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.arrExpProf.count; i++){
        NSDictionary *object = self.arrExpProf[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [arrTmpExpProf addObject:tmp];
    }
    
    NSMutableArray *arrTmpInnovPlan = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.arrInnovPlan.count; i++){
        NSDictionary *object = self.arrInnovPlan[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [arrTmpInnovPlan addObject:tmp];
    }
    
    
    NSDictionary *section1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle1,@"nombre",
                              arrTmpAdmDir,@"departamento",
                              @"1",@"visible",nil];
    
    NSDictionary *section2 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle2,@"nombre",
                              arrTmpDesProVinc,@"departamento",
                              @"1",@"visible",nil];
    
    NSDictionary *section3 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle3,@"nombre",
                              arrTmpEvaRetro,@"departamento",
                              @"1",@"visible",nil];
    
    NSDictionary *section4 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle4,@"nombre",
                              arrTmpExpProf,@"departamento",
                              @"1",@"visible",nil];
    
    NSDictionary *section5 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle5,@"nombre",
                              arrTmpInnovPlan,@"departamento",
                              @"1",@"visible",nil];
    
    //Los cargamos en el array principal
    
    self.tableData = @[section1,section2,section3, section4, section5];
    
    //Recargamos la tabla
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Devolvemos el número de secciones
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Cargamos los datos de la sección
    NSDictionary *dataSection = [self.tableData objectAtIndex:section];
    NSArray *sectionSubnombres = [dataSection objectForKey:@"departamento"];
    BOOL visible = [[dataSection objectForKey:@"visible"] boolValue];
    
    //Comprobamos si el flag "visible" está activo o no. Si lo está mostramos las ciudades si no,
    //se mostrará una sección vacía (oculta)
    if (visible) {
        return [sectionSubnombres count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Accedemos a la celda
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //Cargamos los datos de la sección
    NSDictionary *dataSection = [self.tableData objectAtIndex:indexPath.section];
    NSArray *sectionSubnombres = [dataSection objectForKey:@"departamento"];
    
    //Modificamos la celda con el texto correspondiente dentro de la sección
    [cell.textLabel setText:[sectionSubnombres objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Cargamos el título de la sección
    NSDictionary *dataSection = [self.tableData objectAtIndex:section];
    NSString *sectionTitle = [dataSection objectForKey:@"nombre"];
    
    //Creamos un botón que contiene el título y que al pulsarlo modificará la visibilidad de la sección
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    [headerView setTitle:sectionTitle forState:UIControlStateNormal];
    [headerView setBackgroundColor:[UIColor colorWithRed:87.0f/255.0f green:110.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];
    [headerView addTarget:self action:@selector(updateSectionVisibility:) forControlEvents:UIControlEventTouchUpInside];
    [headerView setTag:section];
    
    //Devolvemos el botón
    return headerView;
}

- (void)updateSectionVisibility:(UIButton*)sender
{
    //Cargamos una copia mutable de la sección cuya visibilidad se va a modificar
    NSMutableDictionary *sectionToModify = [[self.tableData objectAtIndex:sender.tag] mutableCopy];
    
    //Se carga el valor del flag "visible" pero invertido
    BOOL sectionVisibility = ![[sectionToModify objectForKey:@"visible"] boolValue];
    
    //Se actualiza el valor del flag en la copia mutable
    [sectionToModify setObject:[NSNumber numberWithBool:sectionVisibility] forKey:@"visible"];
    
    //Cargamos una copia mutable de los datos
    NSMutableArray *tableDataCopy = [self.tableData mutableCopy];
    
    //Reemplazamos la sección correspondiente por su copia modificada
    [tableDataCopy replaceObjectAtIndex:sender.tag withObject:sectionToModify];
    
    //Volvemos a cargar los datos y recargamos la tabla
    self.tableData = tableDataCopy;
    [self.tableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSInteger tmpInt = [indexPath section];
    NSInteger tmpRow = [indexPath row];
    
    ContactoViewController *cvc = [segue destinationViewController];
    
    NSDictionary *object;
    switch (tmpInt) {
        case 0:
            object = self.arrAdmDir[tmpRow];
            break;
            
        case 1:
            object = self.arrDesProVinc[tmpRow];
            break;
            
        case 2:
            object = self.arrEvaRetro[tmpRow];
            break;
            
        case 3:
            object = self.arrExpProf[tmpRow];
            break;
            
        case 4:
            object = self.arrInnovPlan[tmpRow];
            break;
            
        default:
            break;
    }
    
    cvc.nom = [object objectForKey:@"nombre"];
    cvc.area = [object objectForKey:@"area"];
    cvc.tel = [object objectForKey:@"telefono"];
    cvc.email = [object objectForKey:@"mail"];
    
}

@end

/* https://gpmess.com/blog/2014/04/02/implementar-en-ios-una-lista-desplegable/ */
