Screenshots
===========

.. image:: https://raw.github.com/vaxXxa/dotfiles/master/screenshot-general.png
    :alt: dotfiles
    :align: center

.. image:: https://raw.github.com/vaxXxa/dotfiles/master/screenshot-neovim.png
    :alt: vim
    :align: center


vaxXxa's dotfiles
=================

Pre-installation
----------------

*Note: this setup works only on Mac OS X*

1. Install Homebrew_.
2. Install unix shell – zsh_ (Z shell) and set ``zsh`` as your `default shell`_.
3. Install zsh configuration framework oh-my-zsh_.
4. Install universal-ctags:

.. code:: bash

    $ brew tap universal-ctags/universal-ctags
    $ brew install --HEAD universal-ctags

5. Install zsh-completions, zsh-autosuggestions, zsh-syntax-highlighting:

.. code:: bash

    $ git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
    $ git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    $ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

6. Install Powerlevel10k:

.. code:: bash

    $ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

7. `Install`_ Visual Studio Code shell command 'code'.

Installation
------------

You can clone the repository wherever you want (I like to keep it in ``~/Projects/dotfiles``). The bootstrapper script will pull in the latest version and copy the files to your home folder.

.. code:: bash

    $ git clone git@github.com:vaxXxa/dotfiles.git && cd dotfiles && make

To update, ``cd`` into your local ``dotfiles`` repository and then:

.. code:: bash

    $ make


Add custom commands without creating a new fork
-----------------------------------------------

If ``~/.extra/.zsh/local.zsh`` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My ``~/.extra/.zsh/local.zsh`` looks something like this:

.. code:: bash

    # Git credentials
    git config --global user.name "Vasyl Nakvasiuk"
    git config --global user.email "vaxxxa@gmail.com"

    # Go environment
    export GOROOT=/usr/local/opt/go/libexec
    export GOPATH=$HOME/Projects/gocode
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

    source /usr/local/bin/virtualenvwrapper.sh

You can overwrite something using ``~/.extra/.zsh/local.zsh``. For example:

.. code:: bash

    # Overwrite alias
    alias p="cd ~/Documents/Projects"

    # Overwrite environment variable
    export EDITOR="emacs"

Or you can extend all your dotfiles configuration using ``~/.extra/.zsh/local.zsh`` like entry point. Your ``~/.extra/.zsh/local.zsh`` can be like this:

.. code:: bash

    for file in ~/.extra/.zsh/{local-exports,local-aliases,local-work-settings}.zsh; do
        [ -r "$file" ] && source "$file"
    done
    unset file

And in ``~/.extra/.zsh/local-exports.zsh``, ``~/.extra/.zsh/local-aliases.zsh``, ``~/.extra/.zsh/local-work-settings.zsh`` you can add your own custom commands.


Colorscheme and font
--------------------

I'm using "Base16 Eighties Dark 256" colorscheme and `"Fira Code"`_ + `"Fira Code Nerd Font"`_. Colorscheme files you can find at ``.extra/.zsh/base16-shell/`` folder. Also I set different font size for ASCII and non-ASCII characters.

.. image:: https://raw.github.com/vaxXxa/dotfiles/master/screenshot-iterm2-fonts.png
    :alt: fonts
    :align: center


Thanks to...
------------

`Mathias Bynens`_ for sharing his `amazing collection of dotfiles`_.

`Chris Hunt`_ for nice `dotfiles collection`_.

`Chris Kempson`_ for awesome `color schemes`_.

.. _Homebrew: http://brew.sh/
.. _zsh: http://www.zsh.org/
.. _default shell: http://zanshin.net/2013/09/03/how-to-use-homebrew-zsh-instead-of-max-os-x-default/
.. _oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh
.. _Mathias Bynens: https://github.com/mathiasbynens
.. _amazing collection of dotfiles: https://github.com/mathiasbynens/dotfiles
.. _Chris Hunt: https://github.com/chrishunt
.. _dotfiles collection: https://github.com/chrishunt/dot-files
.. _Chris Kempson: https://github.com/chriskempson
.. _color schemes: https://github.com/chriskempson/base16
.. _Python support: https://neovim.io/doc/user/nvim_python.html
.. _"Fira Code": https://github.com/tonsky/FiraCode
.. _"Fira Code Nerd Font": https://github.com/ryanoasis/nerd-fonts
.. _Install: https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
