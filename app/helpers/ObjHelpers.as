package app.helpers {
    public function _(obj, initial) {
        if (!obj) obj = initial;
        return obj;
    }
    
    Object.prototype.merge = function(other:Object) {
        if (this == other) return;
        for (var i in other) {
            this[i] = this[i] || other[i];
        }
    }
    // obj = null;
    // _(obj, {}).merge({ hello: 'world'});
}
