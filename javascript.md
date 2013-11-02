JavaScript
==========

```js
// define the Person Class
function Person() {}

Person.prototype.walk = function(){
  alert ('I am walking!');
};
Person.prototype.sayHello = function(){
  alert ('hello');
};

// define the Student class
function Student() {
  // Call the parent constructor
  Person.call(this);
}

// inherit Person
Student.prototype = new Person();

// correct the constructor pointer because it points to Person
Student.prototype.constructor = Student;
 
// replace the sayHello method
Student.prototype.sayHello = function(){
  alert('hi, I am a student');
}

// add sayGoodBye method
Student.prototype.sayGoodBye = function(){
  alert('goodBye');
}

var student1 = new Student();
student1.sayHello();
student1.walk();
student1.sayGoodBye();

// check inheritance
alert(student1 instanceof Person); // true 
alert(student1 instanceof Student); // true
```

http://badassjs.com/
https://github.com/felixge/node-style-guide#nodejs-style-guide
