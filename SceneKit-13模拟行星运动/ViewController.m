//
//  ViewController.m
//  SceneKit-13模拟行星运动
//
//  Created by ShiWen on 2017/7/7.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

#define EARTHROTATIONANGLE 5

@interface ViewController ()

@property (nonatomic,strong)SCNView *mScnView;
//太阳系，相机
@property (nonatomic,strong)SCNNode *thirdCamera;
//地月系相机
@property (nonatomic,strong)SCNNode *firstCamera;
@property (nonatomic,strong) SCNNode *addLight;
@property (weak, nonatomic) IBOutlet UIButton *universe;

@property (weak, nonatomic) IBOutlet UIButton *sun;
@property (weak, nonatomic) IBOutlet UIButton *earth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mScnView];
    [self.view addSubview:self.universe];
    [self.view addSubview:self.sun];
    [self.view addSubview:self.earth];
    [self addThePlanet];

}
//添加行星
-(void)addThePlanet{
//    创建太阳
    SCNNode *sunNode = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:3]];
    sunNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"sun.jpg"];
    sunNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;

    [self.mScnView.scene.rootNode addChildNode:sunNode];
//    太阳自转
    SCNAction *sunActin = [SCNAction rotateByAngle:2*M_PI aroundAxis:SCNVector3Make(0, 1, 0) duration:3*EARTHROTATIONANGLE];
    [sunNode runAction:[SCNAction repeatActionForever:sunActin]];
    
//    创建地月系节点
    SCNNode *earthMoonNode = [SCNNode node];
    earthMoonNode.position = SCNVector3Make(10, 0, 0);
    [sunNode addChildNode:earthMoonNode];
    
//    创建地球
    SCNNode *earthNode = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:1]];
    earthNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"earth.jpg"];
    [earthMoonNode addChildNode:earthNode];
    
//    地球自转
    SCNAction *earthActin = [SCNAction rotateByAngle:2*M_PI aroundAxis:SCNVector3Make(0, 1, 0) duration:EARTHROTATIONANGLE];
    [earthNode runAction:[SCNAction repeatActionForever:earthActin]];
    
//    创建月球
    SCNNode *moonNode = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:0.3]];
    moonNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"moon.jpg"];
    moonNode.position = SCNVector3Make(2, 0, 0);
    [earthNode addChildNode:moonNode];
    
//    月球自转
    SCNAction *moonAction = [SCNAction rotateByAngle:2*M_PI aroundAxis:SCNVector3Make(0, 1, 0) duration:1.5*EARTHROTATIONANGLE];
    [moonNode runAction:[SCNAction repeatActionForever:moonAction]];
    
//    添加相机
    [self.mScnView.scene.rootNode addChildNode:self.thirdCamera];
    [earthMoonNode addChildNode:self.firstCamera];
//    当前视角
    self.mScnView.pointOfView = self.thirdCamera;
    
//    添加灯光
    [sunNode addChildNode:self.addLight];
    
    
}

-(SCNNode *)addLight{
    if (!_addLight) {
        _addLight = [SCNNode node];
        _addLight.light = [SCNLight light];
        _addLight.light.color = [UIColor whiteColor];
        _addLight.light.type = SCNLightTypeOmni;
//      光衰减开始
        _addLight.light.attenuationEndDistance = 100;
        _addLight.light.attenuationStartDistance = 1;
    }
    return _addLight;
    
    
}
//宇宙
- (IBAction)universe:(id)sender {
    SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 100) duration:1];
    [self.thirdCamera runAction:move];
    self.mScnView.pointOfView = self.thirdCamera;
}
- (IBAction)sun:(id)sender {
    self.mScnView.pointOfView = self.thirdCamera;

    SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 30) duration:1];
    [self.thirdCamera runAction:move];
}
- (IBAction)earth:(id)sender {
    self.mScnView.pointOfView = self.firstCamera;
}

-(SCNNode *)thirdCamera{
    if (!_thirdCamera) {
        _thirdCamera = [SCNNode node];
        _thirdCamera.camera = [SCNCamera camera];
        _thirdCamera.position = SCNVector3Make(0, 0, 30);
        
    }
    return _thirdCamera;
}
-(SCNNode *)firstCamera{
    if (!_firstCamera) {
        _firstCamera = [SCNNode node];
        _firstCamera.camera = [SCNCamera camera];
        _firstCamera.position = SCNVector3Make(0, 0, 10);
        
    }
    return _firstCamera;
}
-(SCNView *)mScnView{
    if (!_mScnView) {
        _mScnView = [[SCNView alloc] initWithFrame:self.view.bounds];
        _mScnView.backgroundColor = [UIColor blackColor];
        _mScnView.allowsCameraControl = YES;
        _mScnView.scene = [SCNScene scene];
        
    }
    return _mScnView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
