package app.controllers {
    import flash.events.Event;
    import app.controllers.AnimationSteerController;
    import app.controllers.ShooterController;
    import app.interfaces.RunShootDelegate;
    
    public class RunShootController extends AnimationSteerController {
        protected var _shooterController:ShooterController;
        
        public function RunShootController(superView, view, delegate:Object) {
            super(superView, view, delegate);
            
            var bulletContainer = _delegate.containerForBullets();
            var collider = _delegate.collisionObjectForBullets();
            _shooterController = new ShooterController(view, bulletContainer, collider, view.scaleX > 0, _delegate.bulletCollidedWithObject);
        }
        
        public override function main(e: Event):void {
            super.main(e);
            
            if (_keys.space.pressed) _shooterController.fireBullet();
        }
        
        public override function reset() {
            _shooterController.clearBullets();
        } 
    }
}