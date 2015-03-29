//
//  TableViewControllerContacto.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 3/26/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "TableViewControllerContacto.h"

@interface TableViewControllerContacto ()


@property (strong, nonatomic) NSArray *exatecs;
@property (strong, nonatomic) NSArray *asesoramiento;
@property (strong, nonatomic) NSArray *pending;

@end

@implementation TableViewControllerContacto



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Cargamos los datos
    NSString *pathPlist;
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List" ofType: @"plist"];
    self.pending = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List Exatec" ofType: @"plist"];
    self.exatecs = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    pathPlist  = [ [NSBundle mainBundle] pathForResource: @"Property List Asesoramiento" ofType: @"plist"];
    self.asesoramiento = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    
    
    //Creamos los datos
    
    NSString *sectionTitle1 = @"Asesoramiento CVC";
    
    NSString *sectionTitle2 = @"Contacto ExaTec";
    
    NSString *sectionTitle3 = @"Departamento 3";
    
    
    NSMutableArray *pendingArr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.pending.count; i++){
        NSDictionary *object = self.pending[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [pendingArr addObject:tmp];
    }
    
    NSMutableArray *exatecArr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.exatecs.count; i++){
        NSDictionary *object = self.exatecs[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [exatecArr addObject:tmp];
    }
    
    NSMutableArray *asesoramientoArr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.asesoramiento.count; i++){
        NSDictionary *object = self.asesoramiento[i];
        NSString *tmp = [object objectForKey:@"nombre"];
        [asesoramientoArr addObject:tmp];
    }
   
    
    NSDictionary *section1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle1,@"title",
                              asesoramientoArr,@"cities",
                              @"1",@"visible",nil];
    
    NSDictionary *section2 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle2,@"title",
                              exatecArr,@"cities",
                              @"1",@"visible",nil];
    
    NSDictionary *section3 = [NSDictionary dictionaryWithObjectsAndKeys:
                              sectionTitle3,@"title",
                              pendingArr,@"cities",
                              @"1",@"visible",nil];
    
    //Los cargamos en el array principal
    
    self.tableData = @[section1,section2,section3];
    
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
    NSArray *sectionSubtitles = [dataSection objectForKey:@"cities"];
    BOOL visible = [[dataSection objectForKey:@"visible"] boolValue];
    
    //Comprobamos si el flag "visible" está activo o no. Si lo está mostramos las ciudades si no,
    //se mostrará una sección vacía (oculta)
    if (visible) {
        return [sectionSubtitles count];
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
    NSArray *sectionSubtitles = [dataSection objectForKey:@"cities"];
    
    //Modificamos la celda con el texto correspondiente dentro de la sección
    [cell.textLabel setText:[sectionSubtitles objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Cargamos el título de la sección
    NSDictionary *dataSection = [self.tableData objectAtIndex:section];
    NSString *sectionTitle = [dataSection objectForKey:@"title"];
    
    //Creamos un botón que contiene el título y que al pulsarlo modificará la visibilidad de la sección
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    [headerView setTitle:sectionTitle forState:UIControlStateNormal];
    [headerView setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:146.0f/255.0f blue:120.0f/255.0f alpha:1.0f]];
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
    NSString *inStr = [@(tmpInt) stringValue];
    
    //NSDictionary *object = self.exatecs[indexPath.row];
    //NSLog([object objectForKey:@"nombre"]);
    
    NSLog(@"%@", inStr);
}

@end

/* https://gpmess.com/blog/2014/04/02/implementar-en-ios-una-lista-desplegable/ */
