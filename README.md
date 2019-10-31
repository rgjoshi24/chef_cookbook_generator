This is a pattern for a generator cookbook structured as a wrapper cookbook.

Unfortunately the Berksfile mechanism to find dependent cookbooks does not work with generators provided to the 'chef generate' command.

_Solution:_ 

- create your repo for your generator cookbook, called say 'chef_generator'
- create a cookbooks directory under it
- run 'chef generate generator' from within the cookbooks dir, to get the wrapped cookbook
- create a second wrapper cookbook in the same directory and customize as needed
- now the dependent/wrapped cookbook can be found, as it is under the same cookbooks directory as the wrapper cookbook

The whole repo for the generator should probably be cloned somewhere other than within your usual cookbooks directory, as it isn't a regular cookbook. One suggestion is to clone it at ~/chef-repo/chef_generator.

If you do that, to use it, put the following in your config.rb (or knife.rb if still using that):

```
chefdk.generator_cookbook "#{ENV['HOME']}/chef-repo/chef_generator/cookbooks/code_generator_wrapper'
```

Then, chef generate command will then use it by default as the generator cookbook. You should see much cleaner output, like this:

```
$ chef generate cookbook example
Generating cookbook example
- Ensuring correct cookbook file content

Your cookbook is ready. Type `cd example` to enter it.
```
