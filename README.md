# von
Finite State Machine

```js
var fsm = require('von');
var consumption = fsm([
  { action: 'eat', from: 'hungry', to: 'satisfied'},
  { action: 'eat', from: 'satisfied', to: 'full' },
  { action: 'eat', from: 'full', to: 'sick' },
  { action: 'rest', from: ['hungry', 'satisfied', 'full', 'sick'], to: 'hungry' }
]);
var bug = consumption('hungry', {
  onrest: function(action, from, to) {
    console.log('Phew');
  },
  exithungry: function(action, from, to, food) {
    console.log("I can survive, ate " + food);
  },
  entersick: function(action, from, to, food) {
    console.log(food + " was too much!");
  }
});
console.log(bug.state);
bug.eat('grass');
console.log(bug.state);
bug.eat('grass');
console.log(bug.state);
bug.eat('grass');
console.log(bug.state);
bug.rest();
```

Output:

```
hungry
I can survive, ate grass
satisfied
full
grass was too much!
sick
Phew
```
