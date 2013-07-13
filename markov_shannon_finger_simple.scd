//Markov Set

//finite state machine

/*

A --> B
B --> B
B --> x
x --> B

Mögliche Ketten:
ABBBB
ABBxBxBB
xBBxBBxxB

*/


/////////////////////////////////////////////////////////////////////////////////////////
//=====================================================================================
//////////////////////////////////////////////////////////////////////////////////////////


(
q = ();


q.compareMarkov = { |q, event, keyEvent, key|
	//[example, keyEvent].postln;
	var keyVal, eventVal;
	if(keyEvent.isNil) { true } {
		if(event.isNil) { false } {
			keyVal = keyEvent.at(key);
			eventVal = event.at(key);
			if(keyVal.isNil) { true } {
				if(eventVal.isNil) { false } {
					eventVal == keyVal
				}
			}
		}
	};
};

/*
// tests
q.compareMarkov((x: 1), (), \x); // passe par tout
q.compareMarkov((x: 1), nil, \x); // false
q.compareMarkov((x: 1), (x: 1), \x);
q.compareMarkov((x: 1), (x: 2), \x); // false
q.compareMarkov((x: 1, y: 3), (x: 1), \y); // true
q.compareMarkov((x: 1), (x: 1, y: 3), \y); // false
*/

(
q.findMarkov = { |q, keyArray, orders, universe|
	var indices = [];
	keyArray = keyArray.reverse; // count backward
	universe = universe ? q.universe;
	universe.size.do { |i|
		var found = true;
		orders.keysValuesDo { |orderKey, order|
			order.do { |j|
				var foundHere = q.compareMarkov(universe.at(i - j), keyArray.at(j), orderKey);
				//[foundHere, i, j, found].postln;
				found = found and: foundHere;
			}
		};
		if(found) { indices = indices.add(i) };
	};
	indices;
}
);



/*
// tests
q.findMarkov([(x:1)], (x:1), [(x:1)]);
q.findMarkov([(x:1)], (x:1), [(x:1), (x: 1)]);
q.findMarkov([(y:1)], (x:1), [(x:1), (x: 1)]);
q.findMarkov([(x:1), (x:2, y:pi)], (x:2), [(x:1), (x: 2)]);
q.findMarkov([(x:1), (x:2, y:pi)], (x:2), [(x:1), (x: 2)]);
*/


q.nextMarkov = { |q, key, orders, universe| // (x: 1, y: 2) oder: (y:1)
	var all, allNext;
	universe = universe ? q.universe;
	if(key.isKindOf(Array).not) { key = [key] };
	all = q.findMarkov(key.asArray, orders, universe);
	[\allIndices, all].postln;
	allNext = all + 1;
	allNext = allNext.reject { |index| index >= universe.size };
	if(allNext.notEmpty) {
		universe.at(allNext.choose)
	}
};


q.markovSeries = { |q, start, length, orders, universe|
	var key, res, maxOrder, foundItem;
	maxOrder = orders.maxItem;
	res = start.copy;

	block { |ret|
		length.do {
			key = res.keep(maxOrder.neg);
			foundItem = q.nextMarkov(key, orders, universe);
			if(foundItem.notNil) { res = res.add(foundItem) } { ret.value }
		};
	};

	res
};


q.markovPattern = { |q, start, length, orders, universe|
	Prout {
		var key, res, maxOrder, foundItem;
		maxOrder = orders.maxItem;
		res = start.copy;
		length.do {
			key = res.keep(maxOrder.neg);
			foundItem = q.nextMarkov(key, orders, universe);
			if(foundItem.notNil) {
				res = res.add(foundItem);
				foundItem.yield;
			} {
				nil.alwaysYield;
			}
		}
	}
};

q.universe = [
	( 'y': \AA, 'x': \BB ), // 0
	( 'y': \PP, 'x': \OO ), // 1
	( 'y': \PP, 'x': \BB ), // 2
	( 'y': \AA, 'x': \PP ), // 3
	( 'y': \NN, 'x': \NN ), // 4
	( 'y': \AA, 'x': \BB ), // 5
	( 'y': \PP, 'x': \BB ), // 6
	( 'y': \PP, 'x': \PP ), // 7
	( 'y': \AA, 'x': \PP ), // 8
	( 'y': \NN, 'x': \OO ) // 9
];
)


//Tests
/*

q.compareMarkov(q.universe.at(0), (y: \ZZ), \y); // false
q.compareMarkov(q.universe.at(0), (y: \AA), \y); // true


q.findMarkov([(y: \AA), (y: \PP)], (y: 1), q.universe); // order 1: found [ 1, 2, 6, 7 ]
q.findMarkov([(y: \PP)], (y: 1), q.universe); // order 1: found [ 1, 2, 6, 7 ]
q.findMarkov([(y: \AA), (y: \PP)], (y: 2), q.universe); // found: [ 1, 6 ]
q.findMarkov([(y: \AA), (y: \PP)], (y: 2), q.universe); // found: [ 1, 6 ]



q.findMarkov([(y: \AA, x: \BB), (y: \PP)], (y: 1, x: 1), q.universe);
q.findMarkov([(y: \AA, x: \BB), (y: \PP)], (y: 2, x: 1), q.universe);

q.nextMarkov([(y: \AA), (y: \PP)], (y: 2), q.universe);


*/


q.markovSeries([(y: \PP)], 10, (y: 1), q.universe).do { |x| x.postln };"";
q.markovSeries([(y: \PP, x: \BB)], 10, (y: 1, x: 1), q.universe).do { |x| x.postln };"";
q.markovSeries([(y: \PP, x: \BB)], 10, (y: 2, x: 1), q.universe).do { |x| x.postln };"";


Prand([0, 2, 1], inf).asStream.nextN(8);
Pbind(\x, Pseq([1, 2],1), \y, 4).asStream.nextN(2, ());


a = q.markovPattern([(y: \PP, x: \BB)], 10, (y: 2, x: 1), q.universe);
a = q.markovPattern([(note: 30, dur: 0.25)], 10, (note: 1, dur: 1), q.universe);
x = a.asStream;
x.nextN(12);

a.play;


q.universe = [
	( 'note': 30, 'dur': 0.25 ), // 0
	( 'note': 42, 'dur': 0.25 ), // 1
	( 'note': 37, 'dur': 0.125 ), // 2
	( 'note': 33, 'dur': 0.0625 ), // 3
	( 'note': 30, 'dur': 0.25 ), // 4
	( 'note': 42, 'dur': 0.25 ), // 5
	( 'note': 37, 'dur': 0.125 ), // 6
	( 'note': 33, 'dur': 0.125 ), // 7
	( 'note': 33, 'dur': 0.0625 ), // 8
	( 'note': 30, 'dur': 0.0625 ) // 9
];
