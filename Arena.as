package {
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.URLRequest;
    
    import app.controllers.*;
    import app.views.*;
    import app.models.*;
    
    public class Arena extends MovieClip {
        private var _heroController:CharacterController;
        private var _enemyController:CharacterController;
        
        private var _currentLevel = 1;
        private var _displayingWinAnimation:Boolean = false;
                        
        private var _sounds:Object;
        private var _soundChannel:SoundChannel;
        
        private var _enemies:Array = [
            { name: 'Hvedebot', hitPoints: 70 },
            { name: 'Klammstein', hitPoints: 100 },
            { name: 'Dr. Al Ien', hitPoints: 120 }
        ].map(function(obj) { return new Character(obj) });
        
        public function Arena() {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e: Event = null) {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            _sounds = {
                fight: soundWithPath('Fight.mp3'),
                winning: soundWithPath('Winning.mp3')
            }
            
            winimations.visible = false;
            winimations.animations.stop();
            winimations.stickers.stop();
            
            _heroController = new CharacterController({
                character: { name: 'Der Prinz', hitPoints: 100 },
                characterClip: hero,
                collisionsClip: collisions,
                containerForViews: stage,
                containerForBullets: background,
                bulletsCollision: enemyClips,
                onBulletCollidedWithObject: this.bulletCollidedWithObject
            });
            _heroController.setBarPosition(10, 10);
            
            var dwc:DefinedWalkController = null; // hack to make getDefinitionByName to work correctly.
            _enemyController = new CharacterController({
                character: enemyForLevel(_currentLevel),
                characterClip: enemyClips,
                collisionsClip: collisions,
                containerForViews: stage,
                containerForBullets: background,
                bulletsCollision: hero,
                onBulletCollidedWithObject: this.bulletCollidedWithObject,
                steeringControllerKind: 'app.controllers.DefinedWalkController',
                healthBarConfiguration: {
                    direction: 'right', barColor: 0xFF00FF, backgroundColor: 0x444444
                }
            });
            var barX = stage.stageWidth - _enemyController.bar.width - 10;
            _enemyController.setBarPosition(barX, 10);
            
            gotoLevel(_currentLevel);
        }
        
        public function bulletCollidedWithObject(object:Object) {
            if (object == hero && !winimations.visible) {
                _heroController.removeHealth(_currentLevel * 2);
            } else if (object == enemyClips) {
                _enemyController.removeHealth(1);
            }
            checkIfCharacterHasDied();
        }
        
        public function checkIfCharacterHasDied() {
            if (_heroController.character.isDead())
                reloadLevel();
            else if (_enemyController.character.isDead())
                displayWinAnimationForLevel(gotoNextLevel);
        }
        
        public function changeEnemyClipForLevel(levelNumber) {
            enemyClips.gotoAndStop(levelNumber);
        }
        
        public function enemyForLevel(levelNumber) {
            return _enemies[levelNumber - 1];
        }

        public function displayWinAnimationForLevel(completionHandler) {
            if (_displayingWinAnimation) return;
            
            _displayingWinAnimation = true;
            winimations.visible = true;
            winimations.animations.gotoAndStop(_currentLevel);
            winimations.stickers.gotoAndStop(_currentLevel);
            winimations.stickers.sticker.gotoAndPlay(1);
            
            playSound(_sounds.winning);
            
            if (onLastLevel()) winimations.levelText.visible = false;
            
            if (winimations.nextLevelButton.hasEventListener(MouseEvent.CLICK)) return;
            winimations.nextLevelButton.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) {
                if (onLastLevel()) {
                    completeGame();
                    return;
                }
                    
                _displayingWinAnimation = false;
                nextLevelButtonClicked(e);
                completionHandler();
            });
        }
        
        private function nextLevelButtonClicked(e: MouseEvent) {
            winimations.visible = false;
        }

        // level handling        
        public function reloadLevel() {
            gotoLevel(_currentLevel);
        }
        
        public function gotoLevel(levelNumber) {
            playSound(_sounds.fight);
            
            _heroController.reset();
            
            _enemyController.reset();
            _enemyController.character = enemyForLevel(levelNumber);
            changeEnemyClipForLevel(levelNumber);
            
            background.gotoAndStop(levelNumber);
        }
        
        public function gotoNextLevel() {
            gotoLevel(_currentLevel += 1);
        }
        
        public function onLastLevel() {
            return _currentLevel == enemyClips.totalFrames;
        }
        
        public function completeGame() {
            stage.removeChild(_heroController.bar);
            stage.removeChild(_enemyController.bar);
            
            dispatchEvent(new Event('gameEnded', true));
        }
        
        private function playSound(sound) {
            if (_soundChannel) _soundChannel.stop();
            _soundChannel = sound.play();
        }
        
        private function soundWithPath(filePath) {
            return new Sound(new URLRequest(filePath));
        }
    }
}