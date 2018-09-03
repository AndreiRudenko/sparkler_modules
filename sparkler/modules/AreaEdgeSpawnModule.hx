package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleData;
import sparkler.core.ParticleModule;
import sparkler.core.Components;
import sparkler.data.Vector;


class AreaEdgeSpawnModule extends ParticleModule {


	public var size(default, null):Vector;
	public var size_max(default, null):Vector;

	var rnd_point:Vector;


	public function new(_options:AreaEdgeSpawnModuleModuleOptions) {

		super(_options);

		size = _options.size != null ? _options.size : new Vector(64, 64);
		size_max = _options.size_max != null ? _options.size_max : new Vector(128, 128);

		rnd_point = new Vector();

		_priority = -999;
		
	}

	override function onspawn(p:Particle) {

		var pd:ParticleData = emitter.show_particle(p);

		var sx:Float = emitter.random_float(size.x, size_max.x);
		var sy:Float = emitter.random_float(size.y, size_max.y);

		random_point_on_rect_edge(sx, sy);
		rnd_point.x -= sx * 0.5;
		rnd_point.y -= sy * 0.5;
		pd.x = emitter.system.position.x + emitter.position.x + rnd_point.x;
		pd.y = emitter.system.position.y + emitter.position.y + rnd_point.y;

	}

	override function onunspawn(p:Particle) {

		emitter.hide_particle(p);

	}

	inline function random_point_on_rect_edge(width:Float, height:Float) : Vector {

		var rnd_edge_len = emitter.random() * (width * 2 + height * 2);

		if (rnd_edge_len < height){

			rnd_point.x = 0;
			rnd_point.y = height - rnd_edge_len;
			
		} else if (rnd_edge_len < (height + width)){

			rnd_point.x = rnd_edge_len - height;
			rnd_point.y = 0;

		} else if (rnd_edge_len < (height * 2 + width)){

			rnd_point.x = width;
			rnd_point.y = rnd_edge_len - (width + height);

		} else {

			rnd_point.x = width - (rnd_edge_len - (height * 2 + width));
			rnd_point.y = height;

		}

		return rnd_point;

	}


// import/export

	override function from_json(d:Dynamic) {

		super.from_json(d);

		size.from_json(d.size);
		size_max.from_json(d.size_max);

		return this;
	    
	}

	override function to_json():Dynamic {

		var d = super.to_json();

		d.size = size.to_json();
		d.size_max = size_max.to_json();

		return d;
	    
	}


}

typedef AreaEdgeSpawnModuleModuleOptions = {

	>ParticleModuleOptions,

	@:optional var size:Vector;
	@:optional var size_max:Vector;

}
