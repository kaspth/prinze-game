package app.interfaces {
    public interface MovementControllerDelegate {
        function collisionsForView(view); // view is the view we're steering. Should return the object that a view can collide with
    }
}