package app.interfaces {
    import app.interfaces.MovementControllerDelegate;
    
    public interface RunShootDelegate extends MovementControllerDelegate {
        function containerForBullets(); // return the container with which the bullets should be added to.
        function collisionObjectForBullets(); // the object you want to know if the bullet collided with.
        function bulletCollidedWithObject(object:Object); // the object is passed in for good measure.
    }
}