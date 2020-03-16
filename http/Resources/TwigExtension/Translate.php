<?php
/*
 * This file is part of Nerd (Named Entity Recognition Dashboard).
 *
 * (c) Boulevard Software (hello@blvd.ai)
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace Nerd\Resources\TwigExtension;

use Illuminate\Translation\Translator;

/**
 * Registers the Illuminate Translator as a the trans and transChoice functions in Twig.
 * The variable app.locale is registered as a global twig variables.
 */
class Translate extends \Twig_Extension implements \Twig_Extension_GlobalsInterface
{
    /**
     * @var Translator
     */
    private $translator;

    public function __construct(Translator $translator)
    {
        $this->translator = $translator;
    }

    public function getName()
    {
        return 'slim_translator';
    }

    public function getFunctions()
    {
        return [
            new \Twig_SimpleFunction('trans', [$this->translator, 'trans']),
            new \Twig_SimpleFunction('transChoice', [$this->translator, 'transChoice']),
        ];
    }

    public function getGlobals()
    {
        return [
            'app' => ['locale' => $this->translator->getLocale()],
        ];
    }
}
