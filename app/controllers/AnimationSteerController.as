package app.controllers {
    import flash.events.Event;
    import app.controllers.MovementController;
    import app.controllers.ShooterController;
    
    // look into if this should be inverted, so that the Controller knows about the object it is steering.
    public class AnimationSteerController extends MovementController {
        public function AnimationSteerController(superView, view, delegate:Object) {
            super(superView, view, delegate);
        }
        
        public override function main(e:Event):void {
            super.controlBumpingSides();
        
            super.walkIfKeyPressed(_keys.left.pressed, -_speedConstant);
            super.walkIfKeyPressed(_keys.right.pressed, _speedConstant);
            
            var closeToEdge:Boolean = (_bumpingSides.left && _xSpeed < 0) || (_bumpingSides.right && _xSpeed > 0);
            if (closeToEdge) _xSpeed *= -0.5; // turn around
        
            if (_bumpingSides.up && _ySpeed < 0) _ySpeed *= -0.5; 
                        
            if (_bumpingSides.down) { //if we are touching the floor
                if (_ySpeed > 0) _ySpeed = 0; //set the y speed to zero
                if (_keys.up.pressed) _ySpeed = _jumpConstant; //if up arrow is pressed
        
            } else //if we are not touching the floor
                _ySpeed += _gravityConstant; //accelerate downwards
        
            if (_xSpeed > _maxSpeedConstant) _xSpeed = _maxSpeedConstant; //moving right
            else if (_xSpeed < -_maxSpeedConstant) _xSpeed = -_maxSpeedConstant; //moving left
            
            _xSpeed *= _frictionConstant;
            _ySpeed *= _frictionConstant;

            if (Math.abs(_xSpeed) < 0.5) _xSpeed = 0; // stop if moving slowly
        
            determineAndChangeAnimation();
            
            _view.x += _xSpeed;
            _view.y += _ySpeed;
        }
        
        private function determineAndChangeAnimation() {
            var animationKey:String = 'idling';
            var running = (_keys.left.pressed || _keys.right.pressed || _xSpeed > _speedConstant || _xSpeed < -_speedConstant) && _bumpingSides.down;

            if (_keys.space.pressed)
                animationKey = 'shooting';
            else if (running)
                animationKey = 'running';
            else if (!_bumpingSides.down)
                animationKey = 'jumping';
            
            changeAnimation(animationKey);
        }
        
        private function changeAnimation(animationKey) {
            if (_view.currentLabel != animationKey) 
                _view.gotoAndStop(animationKey);
        }
    }
}