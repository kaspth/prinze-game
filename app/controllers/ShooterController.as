package app.controllers {
    import flash.display.MovieClip;
    import flash.events.*;
    import app.views.Bullet;
    
    public class ShooterController {
        private var _shooter;
        private var _container:MovieClip;
        private var _collider;
        private var _isRightDirection:Boolean;
        private var _bulletCollisionFunction; // called when the bullet hits the _collider
        
        private var _bullets:Array = [];
        
        public function ShooterController(shooter, viewForBullets, colliderForBullets, isRightDirection, bulletHitFunction) {
            _shooter = shooter;
            _container = viewForBullets;
            _collider = colliderForBullets;
            _bulletCollisionFunction = bulletHitFunction;     
            _isRightDirection = isRightDirection;
            
            shooter.addEventListener(Event.ENTER_FRAME, main);
        }
        
        public function get shooterDirection() {
            return _isRightDirection ? 'right' : 'left';
        }
        
        public function set shooterDirection(direction:String) {
            _isRightDirection = direction == 'right';
        }
        
        private function main(e: Event) {
            hitTestBullets();
        }
        
        public function fireBullet() {
            if (_bullets.length >= 3) return; // only 3 bullets at a time, but the bullets disappear quickly since they hit the enemy
            
            var bullet = new Bullet(_shooter, _isRightDirection, randomYPosition());
            _bullets.push(bullet);
            _container.addChild(bullet);
            bullet.addEventListener(Event.REMOVED, bulletRemovedFromSuperview);
        }
        
        private function bulletRemovedFromSuperview(e: Event) {
            e.target.removeEventListener(e.type, bulletRemovedFromSuperview);
            _bullets.splice(_bullets.indexOf(e.target), 1);
        }
        
        private function hitTestBullets() {
            if (_bullets.length <= 0) return;
            
            for each (var bullet in _bullets) {
                if (_collider.hitTestObject(bullet)) {
                    bullet.removeFromView();
                    _bulletCollisionFunction(_collider);
                }
            }
        }
        
        public function clearBullets() {
            for each (var bullet in _bullets)
                bullet.removeFromView();
        }
        
        private function randomYPosition() {
            return (_shooter.height * 0.2) + Math.random() * _shooter.height * 0.8 - _shooter.height / 2;
        }
    }
}