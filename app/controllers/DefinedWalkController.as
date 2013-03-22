package app.controllers {
    import flash.events.*;
    import flash.utils.Timer;
    import app.controllers.RunShootController;
    
    public class DefinedWalkController extends RunShootController {
        private var _initialX:Number = 0;
        private var _walkThreshold:int = 60;
        private var _shooterTimer:Timer;
        
        public function DefinedWalkController(superView, view, delegate:Object) {
            super(superView, view, delegate);
            
            _shooterController.shooterDirection = 'left';
            
            _shooterTimer = new Timer(randomSeconds(), 0);
            _shooterTimer.addEventListener(TimerEvent.TIMER, timerFired);
            startTimer();
            
            _xSpeed = 1.5;
            _initialX = _view.x;
        }
        
        public function startTimer() {
            _shooterTimer.start();
        }
        
        public function stopTimer() {
            _shooterTimer.stop();
        }
        
        // don't call super since we don't want a dynamic walk
        public override function main(e: Event):void {
            if (walkedPastThreshold()) turnAround();

            _view.x += _xSpeed;
        }
        
        private function walkedPastThreshold() {
            return (_view.x > _initialX + _walkThreshold || _view.x < _initialX - _walkThreshold);
        }
        
        private function turnAround() {
            _xSpeed = -_xSpeed;
        }
                
        private function changeTimerDelay() {
            _shooterTimer.delay = randomSeconds();
        }
        
        private function timerFired(e: TimerEvent) {
            _shooterController.fireBullet();
            changeTimerDelay();
        }
        
        // somewhere between 1-3 seconds
        private function randomSeconds() {
            return Math.floor((Math.random() + 1) * 1000);
        }
    }
}