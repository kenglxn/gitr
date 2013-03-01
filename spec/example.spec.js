var example = require('../lib/example');

describe('example', function(){
	it('should bar', function(){
        expect(example.foo()).toBe('bar');
    });
});