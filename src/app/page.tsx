import Link from "next/link";

export default function HomePage() {
	return (
		<div className="relative min-h-screen flex bg-gradient-to-br from-indigo-900 via-purple-900 to-gray-900 text-white">
	{/* Hintergrundmuster */}
	<div className="absolute inset-0 -z-10" />

	{/* Liquid Glass Sidebar */}
	<aside className="m-4 w-64 min-h-[calc(100vh-2rem)] p-8 flex flex-col gap-6
		bg-white/10 backdrop-blur-lg border border-white/20
		shadow-xl rounded-xl">
		<h2 className="text-2xl font-bold mb-4 text-purple-200">DreamSlice Interactive</h2>
		<nav className="flex flex-col gap-2">
			<Link href="/" className="hover:underline text-purple-100 hover:text-white">Home</Link>
			<Link href="/gallery" className="hover:underline text-purple-100 hover:text-white">Gallery</Link>
			<Link href="/about" className="hover:underline text-purple-100 hover:text-white">About</Link>
		</nav>
	</aside>

	{/* Main Content */}
	<main className="flex-1 flex flex-col items-center justify-center">
		<h1 className="text-4xl font-extrabold mb-4">Welcome to DreamSlice Interactive</h1>
		<p className="text-lg mb-8 text-purple-100">Website in progress – stay tuned!</p>
	</main>
</div>

	);
}
