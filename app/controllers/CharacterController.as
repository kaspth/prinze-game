package app.controllers {
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;
    
    import app.models.Character;
    import app.controllers.*;
    import app.interfaces.RunShootDelegate;
    
    public class CharacterController extends Object implements RunShootDelegate {
        private var _character:Character;
        private var _healthBarController:HealthBarController;
        private var _steeringController;
        private var _characterClip:MovieClip; // character view. Required
        private var _collisionsClip:MovieClip; // the clip which contents the character can collide with. Required
        
        private var _containerForBullets;
        private var _bulletsCollision:Object;
        private var _bulletCollidedFunction;
        
        private var _options:Object = {
            character: new Character(),
            collisionsClip: null,
            characterClip: null
        }
        // @view where to insert the healthBar
        public function CharacterController(conf:Object = null) {
            if (!conf) conf = _options;
            for (var i in _options)
                conf[i] = conf[i] || _options[i];
                
            _character = new Character(conf.character);
            
            _healthBarController = new HealthBarController(conf.healthBarConfiguration);
            _healthBarController.character = _character;
            conf.containerForViews.addChild(_healthBarController.view);
            
            _containerForBullets = conf.containerForBullets;
            _bulletsCollision = conf.bulletsCollision;
            _bulletCollidedFunction = conf.onBulletCollidedWithObject;
            
            if (!conf.collisionsClip) throw new Error('A MovieClip with the things a character can collide with is required');
            _collisionsClip = conf.collisionsClip;
            if (!conf.characterClip) throw new Error('A MovieClip with the character is required');
            _characterClip = conf.characterClip;
            
            // hack to make getDefinitionByName to function correctly
            var rsc:RunShootController = null; 
            
            var steeringDef = conf.steeringControllerKind;
            if (!steeringDef) steeringDef = 'app.controllers.RunShootController';
            var steeringClass:Class = getDefinitionByName(steeringDef) as Class;
            _steeringController = new steeringClass(conf.containerForViews, _characterClip, this);
        }
        
        // keep characters hp in sync with healthBar
        public function get character() {
            return _character;
        }
        public function set character(character) {
            _character = character;
            _healthBarController.character = _character;
        }
        public function get characterClip() {
            return _characterClip;
        }
        public function set characterClip(clip) {
            _characterClip = clip;
        }
        
        public function regainHealth() {
            _character.regainHealth();
            _healthBarController.resetHealth();
        }
        
        public function removeHealth(amount) {
            _character.takeDamage(amount);
            _healthBarController.removeHealth(amount);
        }
        
        public function reset() {
            _steeringController.reset();
            regainHealth();
        }
        
        public function get bar() {
            return _healthBarController.view;
        }
        public function get barPosition() {
            return _healthBarController.position;
        }
        public function setBarPosition(x:int, y:int) {
            return _healthBarController.setPosition(x, y);
        }
        
        // MovementControllerDelegate
        public function collisionsForView(view) {
            return view == _characterClip ? _collisionsClip : null;
        }
                
        public function containerForBullets() {
            return _containerForBullets;
        }
        
        public function collisionObjectForBullets() {
            return _bulletsCollision;
        }
        
        public function bulletCollidedWithObject(object:Object) {
            _bulletCollidedFunction(object);
        }
    }
}