import Foundation
#if swift(>=3)
import ReactiveSwift
#else
import ReactiveCocoa
#endif
import Result

// MARK: - MachOType.swift

extension MachOType {
	@available(*, unavailable, renamed="from(string:)")
	public static func fromString(string: String) -> Result<MachOType, Error> { fatalError() }
}

// MARK: - ProductType.swift

extension ProductType {
	@available(*, unavailable, renamed="from(string:)")
	public static func fromString(string: String) -> Result<ProductType, Error> { fatalError() }
}

// MARK: - SDK.swift

extension SDK {
	@available(*, unavailable, renamed="from(string:)")
	public static func fromString(string: String) -> Result<SDK, Error> { fatalError() }
}

// MARK: - Xcode.swift

@available(*, unavailable, renamed="ProjectLocator.locate(in:)")
public func locateProjectsInDirectory(directoryURL: URL) -> SignalProducer<ProjectLocator, Error> { fatalError() }

@available(*, unavailable, renamed="ProjectLocator.schemes(self:)")
public func schemesInProject(project: ProjectLocator) -> SignalProducer<String, Error> { fatalError() }
