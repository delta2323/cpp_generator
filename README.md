generator for c++ class(.cpp, .hpp, unittest, mainfile)

Print Usage

```bash
$ cpp_generator.rb --help
```

Example

```bash
$ cpp_generator.rb  --classname id_generator --namespace foo::bar --source_convention snake --class_convention upper_camel --main
```

This command will create

- id_generator.hpp
- id_generator.cpp
- id_generator_test.cpp
- id_generator_main.cpp

Template for id_generator will be like the followings:

```cpp
#ifndef IDGENERATOR_HPP_
#define IDGENERATOR_HPP_

namespace foo{
namespace bar{

class IdGenerator{
public:

private:
};

} // foo
} // bar

#endif // IDGENERATOR_HPP_
```
