// v-debounce
import type { Directive, DirectiveBinding } from 'vue';

interface ElType extends HTMLElement {
	handleClick?: () => any;
}

export const debounceDirective: Directive = {
	mounted(el: ElType, binding: DirectiveBinding) {
		if (typeof binding.value !== 'function') {
			throw new Error('v-debounce value must be a function');
		}
		let timer: any = null;
		const delay = parseInt(binding.arg as any) || 500;
		const handler = binding.value;
		el.addEventListener(
			'click',
			() => {
				clearTimeout(timer);
				timer = setTimeout(() => handler(), delay);
			},
			{ passive: false }
		);
	},
};

