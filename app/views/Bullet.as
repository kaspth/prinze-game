package app.views {
    import flash.display.MovieClip;
    import flash.events.*;
    import flash.filters.GlowFilter;
    
    public class Bullet extends MovieClip {
        private var _initialX:Number;
        private var _distanceThreshold:int = 640;
        private var _shooter:MovieClip;
        
        private var _speed:int = 20;
        
        // @suggestedY suggest where the bullet should appear scoped to the shooters y position
        public function Bullet(shooter:MovieClip, isRightDirection:Boolean, suggestedY = null) {
            _initialX = shooter.x;
			
			_shooter = shooter;
            adjustSpeedAndXIfRightDirection(isRightDirection);
            adjustViewForDirection(isRightDirection);
            
            if (!suggestedY) suggestedY = 75;
            y = shooter.y - suggestedY;
            
            addEventListener(Event.ENTER_FRAME, main);
            this.filters = [new GlowFilter(0x76F9FB)];
        }
        
        public function main(e: Event) {
            x += _speed;
            
            if (traveledPastThreshold()) removeSelf();
        }
        
        public function removeFromView() {
            removeSelf();
        }
        
        private function adjustViewForDirection(isRight:Boolean) {
            scaleX = isRight ? scaleX : -scaleX; 
        }
        
        private function adjustSpeedAndXIfRightDirection(isRight:Boolean) {
            if (isRight) {
                x = _shooter.x + (_shooter.width / 2);
            } else {
                _speed = -_speed;
                x = _shooter.x - (_shooter.width / 2);
            }
        }
        
        private function traveledPastThreshold():Boolean {
            var threshold = threshold();
            return (_speed > 0 && x > threshold) || (_speed < 0 && x < threshold); 
        }
        
        private function threshold() {
            if (_speed > 0) return _initialX + _distanceThreshold;
                
            return _initialX - _distanceThreshold;
        }
        private function removeSelf() {
            removeEventListener(Event.ENTER_FRAME, main);
            this.parent.removeChild(this);
        }
    }
}