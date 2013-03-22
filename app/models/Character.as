package app.models {
    public class Character extends Object {
        private var _initialHitPoints:int;
        private var _hitPoints:int;
        private var _name:String;
        
        private var _options:Object = {
            name: 'Unknown Soldier',
            hitPoints: 100
        }
        
        public function Character(conf:Object = null) {
            if (!conf) conf = _options;
            for (var i in _options) conf[i] = conf[i] || _options[i];
            
            _initialHitPoints = conf.hitPoints;
            _hitPoints = conf.hitPoints;
            _name = conf.name;
        }
        
        // getters
        public function get hitPoints() { return _hitPoints; }
        public function set hitPoints(points) { _hitPoints = points; }
        
        public function get name() { return _name; }
        public function set name(name:String) { _name = name; }
        // API
        public function isDead() {
            return _hitPoints <= 0;
        }
        
        public function takeDamage(damage:int) {
            _hitPoints -= damage;
        }
        
        public function regainHealth() {
            _hitPoints = _initialHitPoints;
        }
    }
}