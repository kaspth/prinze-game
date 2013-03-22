package app.views {
    import flash.display.*;
    import app.helpers.ObjHelpers;
    
    public class HealthBar extends Sprite {
        private var _lifeBar:Sprite;
        
        private static const DIRECTION_RIGHT = 'right';
        private static const DIRECTION_LEFT = 'left';
        private var _direction:String;
        private var _rotated:Boolean;
        
        private var _options:Object = {
            x: 0, y: 0, width: 200, height: 25,
            lineColor: 0x000000, barColor: 0xFF0000, 
            backgroundColor: 0x222222,
            direction: DIRECTION_LEFT
        }
        
        public function HealthBar(conf:Object = null) {
            if (!conf) conf = _options;
            merge(conf, _options);
            this.x = conf.x;
            this.y = conf.y;
            
            var background:Sprite = new Sprite();
            addChild(background);
            
            var outline:Graphics = background.graphics;
            outline.lineStyle(3, conf.lineColor);
            drawAroundRect(outline, conf.backgroundColor, conf.width, conf.height);
            
            var bar:Sprite = new Sprite();
            background.addChild(bar);
            _lifeBar = bar;
            
            var inside:Graphics = bar.graphics;
            inside.lineStyle(0, 0x000000);
            drawAroundRect(inside, conf.barColor, conf.width, conf.height);
            
            this.direction = conf.direction;
        }
        
        public function get direction() {
            return _direction;
        }
        
        public function set direction(direction:String) {
            _direction = direction;
            rotateIf(_lifeBar, _direction == DIRECTION_RIGHT, 180, 
                function(num1, num2) { return num1 + num2; }
            );
            rotateIf(_lifeBar, _direction == DIRECTION_LEFT, 0,
                function(num1, num2) { return num1 - num2; }
            );
        }
        
        // Will rotate to @degree if @condition is true
        // Calls @operation for x and y for adjustment
        private function rotateIf(obj:Sprite, condition:Boolean, degree:uint, operation) {
            if (!condition || obj.rotation == degree) return;
            obj.rotation = degree;
            obj.x = operation(obj.x, obj.width); 
            obj.y = operation(obj.y, obj.height);
        }
        
        public function get value() {
            return _lifeBar.scaleX;
        }
        
        public function set value(amount:Number) {
            if (amount < 0) amount = 0;
            _lifeBar.scaleX = amount;
        }
        
        private function drawAroundRect(graphics:Graphics, fillColor:uint, width:Number, height:Number) {
            graphics.beginFill(fillColor);
            graphics.lineTo(width, 0);
            graphics.lineTo(width, height);
            graphics.lineTo(0, height);
            graphics.lineTo(0, 0);
            graphics.endFill();
        }
        
        // helper method 
        // combines keys from one object with the keys from another
        private function merge(one:Object, other:Object) {
            for (var i in other)
                one[i] = one[i] || other[i];
        }
    }
}