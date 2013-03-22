package app.controllers {
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
    import flash.geom.*;
    import app.interfaces.MovementControllerDelegate;
    
    public class MovementController {
        protected var _view:MovieClip; // the view to steer
        // @delegate: object to delegate methods in the MovementControllerDelegate interface to.
        protected var _delegate:Object;
                
        // The speed the _view is moving in a direction
        protected var _xSpeed:Number = 0;
        protected var _ySpeed:Number = 0;
        
        protected var _speedConstant:Number = 4;
        protected var _maxSpeedConstant:Number = 10;
        protected var _frictionConstant:Number = 0.9;
        protected var _gravityConstant:Number = 1.5;
        protected var _jumpConstant:Number = -30;
        
        protected var _bumpPoints:Object;
        protected var _bumpingSides:Object = {
            left: false, right: false, up: false, down: false
        }
        
        protected var _keys:Object = {
            left: { code: Keyboard.LEFT, pressed: false },
            right: { code: Keyboard.RIGHT, pressed: false },
            up: { code: Keyboard.UP, pressed: false },
            space: { code: Keyboard.SPACE, pressed: false }
        }
        
        // creates a controller that can handle movement.
        // takes care of setting the correct state while leaving the looping function subclasses
        // override the main function to start
        // @superView the view to add the keyboard event listeners to
        public function MovementController(superView, view, delegate:Object) {
            _view = view;
            
            superView.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            superView.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            _view.addEventListener(Event.ENTER_FRAME, main);
            
            this.delegate = delegate;
            
            _bumpPoints = bumpPointsForView();
        }
        
        public function get delegate() { return _delegate; }
        public function set delegate(delegate:Object) { 
            if (delegate is MovementControllerDelegate)
                _delegate = delegate; 
            else throw new Error('Delegate must implement MovementControllerDelegate interface');
        }
        
        public function reset() {
            // default does nothing; override to reset state
        }
        
        public function onKeyDown(e: KeyboardEvent) {
            setPressedStateForKeyWithCode(e.keyCode, true);
        }
        
        public function onKeyUp(e: KeyboardEvent) {
            setPressedStateForKeyWithCode(e.keyCode, false);
        }
        
        private function setPressedStateForKeyWithCode(code:uint, pressedState:Boolean) {
            for each (var key in _keys)
                if (key.code == code) key.pressed = pressedState;
        }
        
        // @view the view to calculate bump points for
        // @return object with _keys left, right, up, down with Point values in the views coordinate space.
        // Handles the signed-ness of the points. e.g. + or -.
        // assumes mid bottom registration point - there might be bugs if others attempt to use this... 
        // Investigate changing the registration point
        protected function bumpPointsForView() {
            var x = _view.x;
            var y = _view.y;
            var width = _view.width;
            var height = _view.height;
            return {
                left:  new Point(-width/2, -height/2),
                right: new Point(width/2, -height/2),
                up:    new Point(0, -height),
                down:  new Point(0, 0)
            };
        }
        
        // call from subclasses implementation of main to keep _view within the _delegates returned view
        public function controlBumpingSides() {
            var position = new Point(_view.x, _view.y);
            var collisions = _delegate.collisionsForView(_view);
            if (!collisions) return;
            for (var bump:String in _bumpPoints) {
               _bumpingSides[bump] = isBumping(collisions, unionPoint(position, _bumpPoints[bump]));
            }
        }
        
        protected function isBumping(collision, point) {
            return collision.hitTestPoint(point.x, point.y, true);
        }
        
        protected function unionPoint(point1, point2) {
            return new Point(point1.x + point2.x, point1.y + point2.y);
        }
        
        protected function walkIfKeyPressed(keyPressed:Boolean, speed:Number) {
            if (!keyPressed) return;
            _xSpeed += speed;
        }
        
        public function main(e: Event):void {
            throw new Error('Subclasses must implement main');
        }
    }
}