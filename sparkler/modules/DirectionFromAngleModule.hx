package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleModule;
import sparkler.core.ParticleData;
import sparkler.core.Components;
import sparkler.components.Velocity;
import sparkler.modules.helpers.VelocityUpdateModule;



class DirectionFromAngleModule extends ParticleModule {


	public var direction_variance:Float;
	public var speed:Float;
	public var speed_variance:Float;

	var vel_comps:Components<Velocity>;
	var particles_data:Array<ParticleData>;


	public function new(_options:DirectionFromAngleModuleOptions) {

		super(_options);

		direction_variance = _options.direction_variance != null ? _options.direction_variance : 0;
		speed = _options.speed != null ? _options.speed : 60;
		speed_variance = _options.speed_variance != null ? _options.speed_variance : 0;

	}

	override function init() {

		if(emitter.get_module(VelocityUpdateModule) == null) {
			emitter.add_module(new VelocityUpdateModule());
		}

		vel_comps = emitter.components.get(Velocity);

		particles_data = emitter.particles_data;

	}

	override function ondisabled() {

		var v:Velocity;

		particles.for_each(
			function(p) {
				v = vel_comps.get(p);
				v.x = 0;
				v.y = 0;
			}
		);
		
	}
	
	override function onremoved() {

		emitter.remove_module(VelocityUpdateModule);
		vel_comps = null;
		particles_data = null;
		
	}

	override function onspawn(p:Particle) {

		var angle:Float = 0;
		var spd:Float = speed;

		var pd:ParticleData = particles_data[p.id];
		angle = angle_between_points(
				emitter.system.position.x + emitter.position.x, 
				emitter.system.position.y + emitter.position.y, 
				pd.x,
				pd.y
			);

		if(direction_variance != 0) {
			angle += (direction_variance * emitter.random_1_to_1()) * 0.017453292519943295;
		}

		if(speed_variance != 0) {
			spd += speed_variance * emitter.random_1_to_1();
		}

		var v:Velocity = vel_comps.get(p);
		v.x = spd * Math.cos(angle);
		v.y = spd * Math.sin(angle);

	}

	inline function angle_between_points(ax:Float, ay:Float, bx:Float, by:Float):Float {

		var dy:Float = by - ay;
		var dx:Float = bx - ax;

		return Math.atan2(dy, dx);

	}


// import/export

	override function from_json(d:Dynamic) {

		super.from_json(d);

		direction_variance = d.direction_variance;
		speed = d.speed;
		speed_variance = d.speed_variance;

		return this;
	    
	}

	override function to_json():Dynamic {

		var d = super.to_json();

		d.direction_variance = direction_variance;
		d.speed = speed;
		d.speed_variance = speed_variance;

		return d;
	    
	}


}


typedef DirectionFromAngleModuleOptions = {

	>ParticleModuleOptions,
	
	@:optional var direction_variance : Float;
	@:optional var speed : Float;
	@:optional var speed_variance : Float;

}


