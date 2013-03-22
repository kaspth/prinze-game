package app.controllers {
    import flash.display.*;
    import flash.text.*;
    import app.views.HealthBar;
    
    import flash.geom.Point;
    import flash.filters.DropShadowFilter;
    
    public class HealthBarController extends Object {
        // views
        private var _view:Sprite; //Container for the other views
        private var _bar:HealthBar;
        private var _nameTextField:TextField;
        
        // models
        private var _character:Object;
        private var _startHealth:Number;
        private var _health:Number;
        
        // initializer
        public function HealthBarController(barConf:Object = null) {
            _view = new Sprite();
            
            _nameTextField = new TextField();
            _nameTextField.autoSize = TextFieldAutoSize.CENTER;
            _nameTextField.defaultTextFormat = defaultFormat();
            _nameTextField.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 10)];
            _view.addChild(_nameTextField);
            
            _bar = new HealthBar(barConf);
            _view.addChild(_bar);
            
            layoutSubviews();
        }
        
        private function defaultFormat() {
            var format:TextFormat = new TextFormat();
            format.align = TextFormatAlign.CENTER;
            format.font = "Futura";
            format.color = 0xFFFFFF; 
            format.size = 20;
            return format;
        }
        
        //accessors
        public function get view() {
            return _view;
        }
        
        public function get barDirection() {
            return _bar.direction;
        }
        
        public function set barDirection(direction:String) {
            _bar.direction = direction;
        }
        
        
        // Characters must contain a name and health value
        public function set character(char:Object) {
            _character = char;
            _nameTextField.text = _character.name as String;
            this.startHealth = _character.hitPoints as Number;
        }
        
        public function get position() {
            return new Point(this.view.x, this.view.y);
        }
        
        public function setPosition(x:int, y:int) {
            this.view.x = x; this.view.y = y;
        }
                
        // health manipulation
        public function removeHealth(amount:Number) {
            this.health -= amount;
        }
        
        public function addHealth(amount:Number) {
            this.health += amount;
        }
        
        public function resetHealth() {
            this.health = _startHealth;       
        }    
        
        // functions for conversion between the bars way of looking at health and ours
        private function get health() {
            return _health * _startHealth;
        }
        
        private function set health(health:Number) {
            _health = health / _startHealth;
            updateBarValue();
        }
        
        private function get startHealth() {
            return _startHealth;
        }
        
        // a change in startHealth forces a refresh in regular health
        private function set startHealth(startHealth:Number) {
            _startHealth = startHealth;
            this.health = _startHealth;
        }
        
        private function updateBarValue() {
            _bar.value = _health;
        }
        
        private function layoutSubviews() {
            _nameTextField.x = (_bar.width - _nameTextField.width) / 2;
            _nameTextField.y = _bar.height;
        }
    }
}