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

use Psr\Http\Message\RequestInterface as Request;
use Twig_Extension;
use Twig_SimpleFunction;

class Csrf extends Twig_Extension
{
    private $csrfName;

    private $csrfValue;

    public function __construct(Request $request)
    {
        $this->csrfName  = $request->getAttribute('csrf_name');
        $this->csrfValue = $request->getAttribute('csrf_value');
    }

    public function getName()
    {
        return 'csrf';
    }

    public function getFunctions()
    {
        return [
            new Twig_SimpleFunction('csrf', [$this, 'csrf'], ['is_safe' => ['html']]),
        ];
    }

    public function csrf()
    {
        return '
            <input type="hidden" name="csrf_name" value="' . $this->csrfName . '">
            <input type="hidden" name="csrf_value" value="' . $this->csrfValue . '">
        ';
    }
}
