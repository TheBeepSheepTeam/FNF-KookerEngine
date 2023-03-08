package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;

using flixel.util.FlxSpriteUtil;

class KookerEnemy extends FlxSprite
{
	static inline var SPEED:Float = 140;

	var brain:FSM;
	var idleTimer:Float;
	var moveDirection:Float;

	public var seesPlayer:Bool;
	public var playerPosition:FlxPoint;

	public var lockMovement:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		var graphic = Paths.image("minigame/kooker/kooker", 'shared');
		loadGraphic(graphic, true, 64, 64);
		setGraphicSize(128, 128);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		drag.x = drag.y = 10;
		width = 8;
		height = 14;
		offset.x = 4;
		offset.y = 2;

		brain = new FSM(chase);
		idleTimer = 0;
		seesPlayer = false;
		playerPosition = FlxPoint.get();
	}

	override public function update(elapsed:Float)
	{
		updateHitbox();

		if (this.isFlickering())
			return;

		if (!lockMovement)
			move();

		brain.update(elapsed);
		super.update(elapsed);
	}

	function move()
	{
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = LEFT;
				else
					facing = RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = UP;
				else
					facing = DOWN;
			}

			switch (facing)
			{
				case LEFT, RIGHT:
					animation.play("lr");

				case UP:
					animation.play("u");

				case DOWN:
					animation.play("d");

				case _:
			}
		}
	}

	public function idle(elapsed:Float)
	{
		// nuthin
	}

	public function chase(elapsed:Float)
	{
		FlxVelocity.moveTowardsPoint(this, playerPosition, Std.int(SPEED));
	}
}

class FSM
{
	public var activeState:Float->Void;

	public function new(initialState:Float->Void)
	{
		activeState = initialState;
	}

	public function update(elapsed:Float)
	{
		activeState(elapsed);
	}
}
