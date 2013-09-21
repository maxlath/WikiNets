Joe Henke's 6.UAP Repo
===

[Homepage](http://jdhenke.github.io/uap/)

[Proposal](./PROPOSAL.md)

## Local Setup

Install dependencies using [virtualenv](https://pypi.python.org/pypi/virtualenv).

```bash
# setup virtual environment
virtualenv env
source env/bin/activate

# install normal dependencies
pip install -r requirements.txt

# install these *special* dependencies
# this is a result of them depending on numpy in their setup.py's
pip install divisi2 csc-pysparse
```

Test to see if it's working by running this in python.

```python
import divisi2
A = divisi2.network.conceptnet_matrix('en')
concept_axes, axis_weights, feature_axes = A.svd(k=100)
predictions = divisi2.reconstruct(concept_axes, axis_weights, feature_axes)
predictions.entry_named('pig', ('right', 'HasA', 'leg'))
predictions.entry_named('pig', ('right', 'CapableOf', 'fly'))
```

I get a ~0.1261 and ~-0.1784 for the last two calls respectively, but I can't say if this is consisent across installs.

## Deploying to [Heroku](https://www.heroku.com/)

This will use the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-command).

```bash
heroku create
git push heroku master
heroku run pip install divisi2 csc-pysparse
heroku logs --tail
```

Check the logs and make sure things look normal then look:
```bash
heroku open
```

## License

See [LICENSE](./LICENSE)
